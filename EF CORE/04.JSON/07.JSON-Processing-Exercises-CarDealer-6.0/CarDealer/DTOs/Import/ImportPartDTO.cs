using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CarDealer.DTOs.Import
{
    public class ImportPartDTO
    {
        public string Name { get; set; } = null!;
        public string Price { get; set; } = null!;
        public string Quantity { get; set; } = null!;
        public string SupplierId { get; set; } = null!;
    }
}
