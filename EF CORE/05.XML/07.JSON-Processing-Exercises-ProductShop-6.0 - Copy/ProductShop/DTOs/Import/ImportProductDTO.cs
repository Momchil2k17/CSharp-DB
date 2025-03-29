using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.Serialization;

namespace ProductShop.DTOs.Import
{
    [XmlType("Product")]
    public class ImportProductDTO
    {
        [Required]
        [XmlElement("name")]
        public string Name { get; set; } = null!;
        [Required]
        [XmlElement("price")]
        public string Price { get; set; } =null!;
        [Required]
        [XmlElement("sellerId")]
        public string SellerId { get; set; } = null!;
        [XmlElement("buyerId")]
        public string? BuyerId { get; set; }
    }
}
