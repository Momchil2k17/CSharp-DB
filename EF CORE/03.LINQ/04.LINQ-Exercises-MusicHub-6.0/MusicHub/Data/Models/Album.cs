﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicHub.Data.Models
{
    public class Album
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(40)]
        public string Name { get; set; } = null!;

        [Required]
        public DateTime ReleaseDate { get; set; }

        public decimal Price=>Songs.Sum(s => s.Price);
        

        [ForeignKey(nameof(Producer))]
        public int? ProducerId { get; set; }

        public Producer Producer { get; set; }=null!;

        public virtual ICollection<Song> Songs { get; set; }=new HashSet<Song>();
    }
}
