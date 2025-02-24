using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace P01_StudentSystem.Data.Models
{
    public class Course
    {
        [Key]
        public int CourseId { get; set; }

        [Required]
        [MaxLength(80)]
        public string Name { get; set; } = null!;

        public string? Description { get; set; }

        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public decimal Price { get; set; }

        public virtual ICollection<Resource> Resources { get; set; } = new HashSet<Resource>();
        public virtual ICollection<Homework> Homeworks { get; set; } = new HashSet<Homework>();
        public virtual ICollection<StudentCourse> StudentsCourses { get; set; } = new HashSet<StudentCourse>();

    }
}
