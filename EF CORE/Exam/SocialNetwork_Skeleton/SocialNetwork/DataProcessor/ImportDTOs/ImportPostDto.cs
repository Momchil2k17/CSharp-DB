using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SocialNetwork.DataProcessor.ImportDTOs
{
    public class ImportPostDto
    {
        [Required]
        [MinLength(5)]
        [MaxLength(300)]
        public string Content { get; set; } = null!;

        [Required]
        public string CreatedAt { get; set; } = null!;

        [Required]
        public string CreatorId { get; set; }
    }
}
