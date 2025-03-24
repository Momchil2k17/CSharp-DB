using CarDealer.Data;
using CarDealer.DTOs.Import;
using CarDealer.Models;
using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;
using System.IO;

namespace CarDealer
{
    public class StartUp
    {
        public static void Main()
        {
            using CarDealerContext dbContext = new CarDealerContext();

            string jsonString = File.ReadAllText("../../../Datasets/sales.json");

            string result = ImportSales(dbContext, jsonString);
            Console.WriteLine(result);
        }
        public static string ImportSuppliers(CarDealerContext context, string inputJson) 
        {
            string result=string.Empty;
            ImportSupplierDTO[]? supplierDTOs=JsonConvert
                .DeserializeObject<ImportSupplierDTO[]>(inputJson);
            if (supplierDTOs != null)
            {
                var suppliers=new List<Supplier>();
                foreach (var supplier in supplierDTOs)
                {
                    if (!IsValid(supplier))
                    {
                        continue;
                    }
                    Supplier supplier1= new Supplier()
                    {
                        Name = supplier.Name,
                        IsImporter = supplier.isImporter,
                    };
                    suppliers.Add(supplier1);
                }
                context.AddRange(suppliers);
                context.SaveChanges();
                result = $"Successfully imported {suppliers.Count}.";
            }

            return result;
        }

        public static string ImportParts(CarDealerContext context, string inputJson)
        {
            string result=string.Empty;
            ImportPartDTO[]? importPartDTOs=JsonConvert.DeserializeObject<ImportPartDTO[]>(inputJson);
            if (importPartDTOs != null)
            {
                var parts=new List<Part>();
                var supliers = context.Suppliers.Select(s => s.Id).ToList();
                foreach (var part in importPartDTOs)
                {
                    if (!IsValid(part))
                    {
                        continue;
                    }
                    bool isPriceValid = decimal.TryParse(part.Price, out decimal productPrice);
                    bool isQuantityValid=int.TryParse(part.Quantity, out int quantity);
                    bool isIdValid=int.TryParse(part.SupplierId, out int id);
                    if (isPriceValid && isQuantityValid && isIdValid && supliers.Contains(id))
                    {
                        Part part1 = new Part()
                        {
                            Name = part.Name,
                            Price=productPrice,
                            Quantity=quantity,
                            SupplierId=id
                        };
                        parts.Add(part1);
                    }
                  


                }
                context.Parts.AddRange(parts);
                context.SaveChanges();
                result = $"Successfully imported {parts.Count}.";
            }
                return result;
        }
        public static string ImportCars(CarDealerContext context, string inputJson)
        {
            string result = string.Empty;

            ImportCarDTO[]? carDtos = JsonConvert.DeserializeObject<ImportCarDTO[]>(inputJson);

            ICollection<Car> cars = new List<Car>();
            ICollection<PartCar> parts = new List<PartCar>();
            ICollection<int> existingPartIds = context.Parts
                    .Select(p => p.Id)
                    .ToArray();

            if (carDtos != null)
            {
                foreach (var carDto in carDtos)
                {
                    if (!IsValid(carDto))
                    {
                        continue;
                    }

                    Car car = new Car()
                    {
                        Make = carDto.Make,
                        Model = carDto.Model,
                        TraveledDistance = carDto.TravelledDistance
                    };

                    cars.Add(car);

                    foreach (var carPart in carDto.PartIds.Distinct())
                    {
                        if (!existingPartIds.Contains(carPart))
                        {
                            continue;
                        }

                        PartCar partCar = new PartCar()
                        {
                            Car = car,
                            PartId = carPart
                        };

                        parts.Add(partCar);
                    }
                }

                context.Cars.AddRange(cars);
                context.PartsCars.AddRange(parts);
                context.SaveChanges();

                result = $"Successfully imported {cars.Count}.";
            }

            return result;
        }
        public static string ImportCustomers(CarDealerContext context, string inputJson)
        {
            string result = string.Empty;

            ImportCustomerDto[]? customerDtos = JsonConvert.DeserializeObject<ImportCustomerDto[]>(inputJson);

            ICollection<Customer> customers = new List<Customer>();

            if (customerDtos != null)
            {
                foreach (ImportCustomerDto customerDto in customerDtos)
                {
                    if (!IsValid(customerDto))
                    {
                        continue;
                    }

                    Customer customer = new Customer
                    {
                        Name = customerDto.Name,
                        BirthDate = customerDto.BirthDate,
                        IsYoungDriver = customerDto.IsYoungDriver
                    };

                    customers.Add(customer);
                }

                context.Customers.AddRange(customers);
                context.SaveChanges();

                result = $"Successfully imported {customers.Count}.";
            }

            return result;
        }
        public static string ImportSales(CarDealerContext context, string inputJson)
        {
            string result = string.Empty;

            ImportSaleDto[]? saleDtos = JsonConvert.DeserializeObject<ImportSaleDto[]>(inputJson);

            ICollection<Sale> sales = new List<Sale>();

            if (saleDtos != null)
            {
                foreach (ImportSaleDto saleDto in saleDtos)
                {
                    if (!IsValid(saleDto))
                    {
                        continue;
                    }

                    Sale sale = new Sale
                    {
                        CarId = saleDto.CarId,
                        CustomerId = saleDto.CustomerId,
                        Discount = saleDto.Discount
                    };

                    sales.Add(sale);
                }

                context.Sales.AddRange(sales);
                context.SaveChanges();

                result = $"Successfully imported {sales.Count}.";
            }

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