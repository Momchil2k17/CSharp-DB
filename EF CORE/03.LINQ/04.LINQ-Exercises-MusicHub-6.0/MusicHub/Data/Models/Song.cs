using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static MusicHub.Data.Models.Enums.Enums;

namespace MusicHub.Data.Models
{
    public class Song
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(20)]
        public string Name { get; set; } = null!;

        [Required]
        public TimeSpan Duration  { get; set; }

        [Required]
        public DateTime CreatedOn  { get; set; }

        [Required]
        public Genre Genre { get; set; }

        [ForeignKey(nameof(Album))]
        public int? AlbumId { get; set; }

        public Album Album { get; set; }=null!;

        [Required]
        [ForeignKey(nameof(Writer))]
        public int WriterId { get; set; }

        public Writer Writer { get; set; } = null!;

        [Required]
        public decimal Price { get; set; }

        public virtual ICollection<SongPerformer> SongPerformers { get; set; } = new HashSet<SongPerformer>();

    }
}
