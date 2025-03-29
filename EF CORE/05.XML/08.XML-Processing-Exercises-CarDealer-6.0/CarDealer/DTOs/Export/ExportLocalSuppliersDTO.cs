using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace CarDealer.DTOs.Export
{
    [XmlType("supplier")]
    public class ExportLocalSuppliersDTO
    {
        [XmlAttribute("id")]
        public string Id { get; set; } = null!;
        [XmlAttribute("name")]
        public string Name { get; set; }=null!;
        [XmlAttribute("parts-count")]
        public string PartsCount { get; set; } = null!;
    }
}
