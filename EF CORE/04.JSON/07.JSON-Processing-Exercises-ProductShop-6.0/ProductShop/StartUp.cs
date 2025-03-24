using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using ProductShop.Data;
using ProductShop.DTOs.Import;
using ProductShop.Models;
using System.ComponentModel.DataAnnotations;
using System.Data;

namespace ProductShop
{
    public class StartUp
    {
        public static void Main()
        {
            using ProductShopContext dbContext=new ProductShopContext();

            string jsonString = File.ReadAllText("../../../Datasets/categories-products.json");

            string results= GetCategoriesByProductsCount(dbContext);
            Console.WriteLine(results);
        }

        public static string ImportUsers(ProductShopContext context, string inputJson) 
        {
            string result=string.Empty;
            ImportUserDTO[]? userDTOs = JsonConvert
                .DeserializeObject<ImportUserDTO[]>(inputJson);

            if (userDTOs!=null)
            {
                var users = new List<User>();
                foreach (var dto in userDTOs)
                {
                    if (!IsValid(dto))
                    {
                        continue;
                    }
                    int? userAge=null;
                    if (dto.Age!=null)
                    {
                        bool isValidAge = int.TryParse(dto.Age, out int parsedAge);
                        if (!isValidAge) 
                        {
                            continue ;
                        }
                        userAge=parsedAge;
                    }
                    User user = new User()
                    {
                        FirstName = dto.FirstName,
                        LastName = dto.LastName,
                        Age = userAge,
                    };
                    users.Add(user);
                }
                context.Users.AddRange(users);
                context.SaveChanges();
                
                result= $"Successfully imported {users.Count}";
            }
            return result;
        }

        public static string ImportProducts(ProductShopContext context, string inputJson) 
        {
            string result = string.Empty;
            ImportProductDTO[]? productDTOs=JsonConvert
                .DeserializeObject<ImportProductDTO[]>(inputJson);

            if (productDTOs != null) 
            {
                var products = new List<Product>();
                var users=context.Users.Select(u=>u.Id).ToList();
                foreach (var dto in productDTOs) 
                {
                    if (!IsValid(dto)) 
                    {
                        continue;
                    }
                    bool isPriceValid = decimal.TryParse(dto.Price, out decimal productPrice);
                    bool isSellerValid = int.TryParse(dto.SellerId, out int sellerId);
                    if((!isPriceValid) || (!isSellerValid)) 
                    {
                        continue;
                    }
                    int? buyerId = null;
                    if (dto.BuyerId != null) 
                    {
                        bool isBuyerValid = int.TryParse(dto.BuyerId, out int parsedBuyerId);
                        if (!isBuyerValid) 
                        {
                            continue;
                        }
                        //if (!users.Contains(parsedBuyerId)) 
                        //{
                        //    continue;
                        //}
                        buyerId = parsedBuyerId;
                    }
                    //if (!users.Contains(sellerId)) 
                    //{
                    //    continue;
                    //}
                    Product product = new Product() 
                    {
                        Name=dto.Name,
                        Price=productPrice,
                        SellerId=sellerId,
                        BuyerId=buyerId,
                    };
                    products.Add(product);
                }
                context.Products.AddRange(products);
                context.SaveChanges();
                result= $"Successfully imported {products.Count}";
            }
            return result;
        }
        public static string ImportCategories(ProductShopContext context, string inputJson) 
        {
            string result = string.Empty;
            ImportCategoryDTO[]? categoryDTOs=JsonConvert
                .DeserializeObject<ImportCategoryDTO[]>(inputJson);

            if (categoryDTOs != null) 
            {
                var categories = new List<Category>();
                foreach (var categoryDTO in categoryDTOs) 
                {
                    if (!IsValid(categoryDTO))
                    {
                        continue;
                    }
                    Category category = new Category()
                    {
                        Name = categoryDTO.Name!
                    };
                    categories.Add(category);
                }
                context.Categories.AddRange(categories);
                context.SaveChanges();
                result = $"Successfully imported {categories.Count}";
            }
            return result;

        }

        public static string ImportCategoryProducts(ProductShopContext context, string inputJson)
        {
            string result = string.Empty;
            ImportCategoriesProdcutsDTO[]? cpDTOs = JsonConvert
                .DeserializeObject<ImportCategoriesProdcutsDTO[]>(inputJson);
            if (cpDTOs != null) 
            {
                var catProd=new List<CategoryProduct>();
                foreach (var cpDTO in cpDTOs) 
                {
                    if (!IsValid(cpDTO))
                    {
                        continue;
                    }
                    bool isProductIdValid=int.TryParse(cpDTO.ProductId,out int prodId);
                    bool isCategoryIdValid=int.TryParse(cpDTO.CategoryId,out int catId);
                    if((!isCategoryIdValid) || (!isProductIdValid)) 
                    {
                        continue;
                    }
                    CategoryProduct cp = new CategoryProduct()
                    {
                        CategoryId = catId,
                        ProductId = prodId,
                    };
                    catProd.Add(cp);
                }
                context.CategoriesProducts.AddRange(catProd);
                context.SaveChanges();

                result= $"Successfully imported {catProd.Count}";
            }
            return result;
        }
        public static string GetProductsInRange(ProductShopContext context)
        {
            var defaultContractResolver = new DefaultContractResolver()
            {
                NamingStrategy = new CamelCaseNamingStrategy()
            };
            var products=context.Products
                .Where(p=>p.Price>=500 && p.Price<=1000)
                .OrderBy(p=>p.Price)
                .Select(p => new
                {
                    p.Name,
                    p.Price,
                    Seller=p.Seller.FirstName+" " +p.Seller.LastName,
                })
                .ToList();
            string jsonResult=JsonConvert.SerializeObject(products,Formatting.Indented,new JsonSerializerSettings()
            {
                ContractResolver=defaultContractResolver
            });
            return jsonResult;
        }
        public static string GetSoldProducts(ProductShopContext context)
        {
            var usersWithSoldProducts = context
                .Users
                .Where(u => u.ProductsSold
                    .Any(p => p.BuyerId.HasValue))
                .Select(u => new
                {
                    u.FirstName,
                    u.LastName,
                    SoldProducts = u.ProductsSold
                        .Where(p => p.BuyerId.HasValue)
                        .Select(p => new
                        {
                            p.Name,
                            p.Price,
                            BuyerFirstName = p.Buyer!.FirstName,
                            BuyerLastName = p.Buyer.LastName
                        })
                        .ToArray()
                })
                .OrderBy(u => u.LastName)
                .ThenBy(u => u.FirstName)
                .ToArray();

            DefaultContractResolver camelCaseResolver = new DefaultContractResolver()
            {
                NamingStrategy = new CamelCaseNamingStrategy()
            };
            string jsonResult = JsonConvert
                .SerializeObject(usersWithSoldProducts, Formatting.Indented, new JsonSerializerSettings()
                {
                    ContractResolver = camelCaseResolver
                });

            return jsonResult;
        }

        public static string GetCategoriesByProductsCount(ProductShopContext context)
        {
            var categories = context.Categories
                .OrderByDescending(c => c.CategoriesProducts.Count)
                .Select(c => new
                {
                    Category=c.Name,
                    ProductsCount = c.CategoriesProducts.Count,
                    AveragePrice = c.CategoriesProducts.Average(cp => cp.Product.Price).ToString("F2"),
                    TotalRevenue = c.CategoriesProducts.Sum(cp => cp.Product.Price).ToString("F2")
                })
                .ToList();
            DefaultContractResolver camelCaseResolver = new DefaultContractResolver()
            {
                NamingStrategy = new CamelCaseNamingStrategy()
            };
            string jsonResult = JsonConvert
                .SerializeObject(categories, Formatting.Indented, new JsonSerializerSettings()
                {
                    ContractResolver = camelCaseResolver
                });
            return jsonResult;
        }
        public static string GetUsersWithProducts(ProductShopContext context)
        {
            var usersWithSoldProducts = context
                .Users
                .Where(u => u.ProductsSold
                    .Any(p => p.BuyerId.HasValue))
                .Select(u => new
                {
                    u.FirstName,
                    u.LastName,
                    u.Age,
                    SoldProducts = new
                    {
                        Count = u.ProductsSold
                            .Count(p => p.BuyerId.HasValue),
                        Products = u.ProductsSold
                            .Where(p => p.BuyerId.HasValue)
                            .Select(p => new
                            {
                                p.Name,
                                p.Price
                            })
                            .ToArray()
                    }
                })
                .ToArray()
                .OrderByDescending(u => u.SoldProducts.Count)
                .ToArray();
            var usersDto = new
            {
                UsersCount = usersWithSoldProducts.Length,
                Users = usersWithSoldProducts
            };

            DefaultContractResolver camelCaseResolver = new DefaultContractResolver()
            {
                NamingStrategy = new CamelCaseNamingStrategy()
            };
            string jsonResult = JsonConvert
                .SerializeObject(usersDto, Formatting.Indented, new JsonSerializerSettings()
                {
                    ContractResolver = camelCaseResolver,
                    NullValueHandling = NullValueHandling.Ignore
                });

            return jsonResult;
        }

        public static bool IsValid(object dto)
        {
            var validateContext = new ValidationContext(dto);
            var validationResults = new List<ValidationResult>();

            bool isValid = Validator.TryValidateObject(dto, validateContext, validationResults, true);

            return isValid;
        }
    }
}