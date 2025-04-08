using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace SocialNetwork.DataProcessor.ImportDTOs
{
    [XmlType("Message")]
    public class ImportMessageDto
    {
        [Required]
        [MinLength(1)]
        [MaxLength(200)]
        [XmlElement("Content")]
        public string Content { get; set; } = null!;

        [Required]
        [XmlElement("Status")]
        public string Status { get; set; } = null!;

        [Required]
        [XmlElement("ConversationId")]
        public int ConversationId { get; set; }

        [Required]
        [XmlElement("SenderId")]
        public int SenderId { get; set; }

        [Required]
        [XmlAttribute("SentAt")]
        public string SentAt { get; set; } = null!;
    }
}
