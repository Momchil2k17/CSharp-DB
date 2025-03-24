using Microsoft.EntityFrameworkCore.ChangeTracking.Internal;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProductShop.DTOs.Import
{
    public class ImportProductDTO
    {
        [Required]
        [JsonProperty(nameof(Name))]
        public string Name { get; set; } = null!;

        [Required]
        [JsonProperty(nameof(Price))]
        public string Price { get; set; }=null!;

        [Required]
        [JsonProperty(nameof(SellerId))]
        public string SellerId { get; set; }=null!;

        [JsonProperty(nameof(BuyerId))]
        public string? BuyerId { get; set; }
    }
}
