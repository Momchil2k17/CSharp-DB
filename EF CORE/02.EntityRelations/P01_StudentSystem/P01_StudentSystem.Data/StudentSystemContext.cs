using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query.Internal;
using P01_StudentSystem.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace P01_StudentSystem.Data
{
    public class StudentSystemContext:DbContext
    {
        public const string ConnectionString = @"Server=.;Database=StudentSystem;Trusted_Connection=True;";
        public StudentSystemContext() { }
        public StudentSystemContext(DbContextOptions options): base(options)
        {

        }
        public virtual DbSet<Student> Students { get; set; }=null!;
        public virtual DbSet<Course> Courses { get; set; }= null!;
        public virtual DbSet<Resource> Resources { get; set; } = null!;
        public virtual DbSet<Homework> Homeworks { get; set; } = null!;
        public virtual DbSet<StudentCourse> StudentsCourses { get; set; }= null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(ConnectionString);
            }
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<StudentCourse>()
                .HasKey(sc => new { sc.StudentId, sc.CourseId });
        }
    }
}
