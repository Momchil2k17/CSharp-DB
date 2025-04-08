using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SocialNetwork.Data.Models
{
    public class Post
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(300)]
        public string Content { get; set; } = null!;

        [Required]
        public DateTime CreatedAt  { get; set; }

        //check if any error
        [Required]
        [ForeignKey(nameof(Creator))]
        public int CreatorId { get; set; }
        public User Creator  { get; set; } = null!;
    }
}
