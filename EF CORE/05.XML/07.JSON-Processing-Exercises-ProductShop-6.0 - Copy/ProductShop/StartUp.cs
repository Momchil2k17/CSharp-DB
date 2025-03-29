using CarDealer.Utilities;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using ProductShop.Data;
using ProductShop.DTOs.Export;
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
            using ProductShopContext context = new ProductShopContext();
            //const string xmlFilePath = "../../../Datasets/categories-products.xml";
            //string inputXml = File.ReadAllText(xmlFilePath);

            string result = GetProductsInRange(context);
            Console.WriteLine(result);
        }
        public static string ImportUsers(ProductShopContext context, string inputXml)
        {
            string result=string.Empty;

            ImportUserDTO[]? userDTOs = XmlHelper.Deserialize<ImportUserDTO[]>(inputXml, "Users");
            if (userDTOs != null)
            {
                ICollection<User> validUsers = new List<User>();
                foreach (var userDTO in userDTOs)
                {
                    if (!(IsValid(userDTO)))
                    {
                        continue;
                    }
                    int? userAge = null;
                    if (userDTO.Age != null)
                    {
                        bool isValidAge = int.TryParse(userDTO.Age, out int parsedAge);
                        if (!isValidAge)
                        {
                            continue;
                        }
                        userAge = parsedAge;
                    }
                    User user = new User()
                    {
                        FirstName = userDTO.FirstName,
                        LastName = userDTO.LastName,
                        Age = userAge,
                    };
                    validUsers.Add(user);
                }
                context.Users.AddRange(validUsers);
                context.SaveChanges();

                result = $"Successfully imported {validUsers.Count}";
            }
            return result;
        }
        public static string ImportProducts(ProductShopContext context, string inputXml)
        {
            string result=string.Empty;
            ImportProductDTO[]? userDTOs = XmlHelper
                .Deserialize<ImportProductDTO[]>(inputXml, "Products");
            if (userDTOs != null)
            {
                ICollection<Product> validProducts = new List<Product>();
                foreach (var userDTO in userDTOs)
                {
                    if (!(IsValid(userDTO)))
                    {
                        continue;
                    }
                    bool isPriceValid = decimal.TryParse(userDTO.Price, out decimal productPrice);
                    bool isSellerValid = int.TryParse(userDTO.SellerId, out int sellerId);
                    if ((!isPriceValid) || (!isSellerValid))
                    {
                        continue;
                    }
                    int? buyerId = null;
                    if (userDTO.BuyerId != null)
                    {
                        bool isBuyerValid = int.TryParse(userDTO.BuyerId, out int parsedBuyerId);
                        if (!isBuyerValid)
                        {
                            continue;
                        }
                        buyerId = parsedBuyerId;
                    }
                    Product product = new Product()
                    {
                        Name = userDTO.Name,
                        Price = productPrice,
                        SellerId = sellerId,
                        BuyerId = buyerId,
                    };
                    validProducts.Add(product);
                }
                context.Products.AddRange(validProducts);
                context.SaveChanges();
                result = $"Successfully imported {validProducts.Count}";
            }
            return result;
        }
        public static string ImportCategories(ProductShopContext context, string inputXml)
        {
            string result = string.Empty;
            ImportCategoryDTO[]? categoryDTOs = XmlHelper
                .Deserialize<ImportCategoryDTO[]>(inputXml, "Categories");
            if (categoryDTOs != null)
            {
                ICollection<Category> validCategories=new List<Category>();
                foreach (var categoryDTO in categoryDTOs) 
                {
                    if (!(IsValid(categoryDTO)))
                    {
                        continue;
                    }
                    Category category = new Category()
                    {
                        Name = categoryDTO.Name
                    };
                    validCategories.Add(category);
                }
                context.AddRange(validCategories);
                context.SaveChanges();
                result= $"Successfully imported {validCategories.Count}";
            }
            return result;
        }
        public static string ImportCategoryProducts(ProductShopContext context, string inputXml)
        {
            string result = string.Empty;
            ImportCategoryProductDTO[]? cpDTOs = XmlHelper
             .Deserialize<ImportCategoryProductDTO[]>(inputXml, "CategoryProducts");
            if (cpDTOs != null) 
            {
                ICollection<CategoryProduct> validCategories=new List<CategoryProduct>();
                //var catIds=context.Categories.Select(c=>c.Id).ToList();
                //var prodIds=context.Products.Select(c=>c.Id).ToList();
                foreach (var cpDTO in cpDTOs) 
                {
                    if (!IsValid(cpDTO))
                    {
                        continue;
                    }
                    bool isCatIdValid = int.TryParse(cpDTO.CategoryId, out int catId);
                    bool isProdIdValid = int.TryParse(cpDTO.ProductId, out int prodId);
                    if (!(isCatIdValid) || !(isProdIdValid)) 
                    {
                        continue;
                    }
                    //if (!(catIds.Contains(catId)) || !(prodIds.Contains(prodId)))
                    //{
                    //    continue;
                    //}
                    CategoryProduct cp = new CategoryProduct()
                    {
                        CategoryId = catId,
                        ProductId = prodId,
                    };
                    validCategories.Add(cp);
                }
                context.CategoriesProducts.AddRange(validCategories);
                context.SaveChanges();
                result = $"Successfully imported {validCategories.Count}";
            }
            return result;
        }
        public static string GetProductsInRange(ProductShopContext context)
        {
            ExportProductDTO[] products=context
                .Products
                .Where(p=>p.Price>=500 && p.Price<=1000)
                .OrderBy(p=>p.Price)
                .Select(p=> new ExportProductDTO()
                {
                    Name = p.Name,
                    Price=p.Price,
                    Buyer=p.Buyer.FirstName+" "+p.Buyer.LastName
                })
                .Take(10)
                .ToArray();
            string result = XmlHelper
                .Serialize(products, "Products");
            return result;
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