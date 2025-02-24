using Microsoft.EntityFrameworkCore;
using SoftUni.Data;
using SoftUni.Models;
using System.Text;

namespace SoftUni
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            var context = new SoftUniContext();
            Console.WriteLine(GetEmployeesByFirstNameStartingWithSa(context));

        }
        public static string GetEmployeesFullInformation(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var employees = context.Employees
                .OrderBy(e => e.EmployeeId)
                .Select(e => new { e.FirstName, e.LastName, e.MiddleName, e.JobTitle, e.Salary })
                .ToList();

            foreach (var employee in employees)
            {
                sb.AppendLine($"{employee.FirstName} {employee.LastName} {employee.MiddleName} {employee.JobTitle} {employee.Salary:f2}");

            }
            return sb.ToString().TrimEnd();
        }
        public static string GetEmployeesWithSalaryOver50000(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var employees = context.Employees
                .Where(e => e.Salary > 50000)
                .Select(e => new
                {
                    e.FirstName,
                    e.Salary
                })
                .OrderBy(e => e.FirstName)
                .ToList();
            foreach (var employee in employees)
            {
                sb.AppendLine($"{employee.FirstName} - {employee.Salary:f2}");
            }
            return sb.ToString().TrimEnd();
        }
        public static string GetEmployeesFromResearchAndDevelopment(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var employees = context.Employees
                .Where(e => e.Department.Name == "Research and Development")
                .OrderBy(e => e.Salary)
                .ThenByDescending(e => e.FirstName)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    DepartmentName = e.Department.Name,
                    e.Salary
                })
                .ToList();

            foreach (var employee in employees)
            {
                sb.AppendLine($"{employee.FirstName} {employee.LastName} from {employee.DepartmentName} - ${employee.Salary:f2}");
            }
            return sb.ToString().TrimEnd();
        }
        public static string AddNewAddressToEmployee(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var newAddress = new Address
            {
                AddressText = "Vitoshka 15",
                TownId = 4
            };
            context.Addresses.Add(newAddress);
            context.SaveChanges();
            var employee = context.Employees
                .FirstOrDefault(e => e.LastName == "Nakov");
            if (employee != null)
            {
                employee.AddressId = newAddress.AddressId;
                context.SaveChanges();
            }

            var employees = context.Employees
                .OrderByDescending(e => e.AddressId)
                .Take(10)
                .Select(e => e.Address.AddressText)
                .ToList();

            foreach (var addressText in employees)
            {
                sb.AppendLine(addressText);
            }

            return sb.ToString().TrimEnd();
        }
        public static string GetEmployeesInPeriod(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var employees = context.Employees.OrderBy(e => e.EmployeeId)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    e.Manager,
                    Projects = e.EmployeesProjects
                    .Select(ep => ep.Project)
                    .Where(p => p.StartDate.Year >= 2001 && p.StartDate.Year <= 2003)
                    .Select(p => new
                    {
                        ProjectName = p.Name,
                        p.StartDate,
                        p.EndDate
                    }).ToList()

                }).Take(10).ToList();
            foreach (var e in employees)
            {
                sb.AppendLine($"{e.FirstName} {e.LastName} - Manager: {e.Manager.FirstName} {e.Manager.LastName}");
                foreach (var ep in e.Projects)
                {
                    sb.AppendLine($"--{ep.ProjectName} - {ep.StartDate.ToString("M/d/yyyy h:mm:ss tt")} - {ep.EndDate?.ToString("M/d/yyyy h:mm:ss tt") ?? "not finished"}");
                }
            }
            return sb.ToString().TrimEnd();
        }
        public static string GetAddressesByTown(SoftUniContext context)
        {
            StringBuilder stringBuilder = new StringBuilder();
            var addresses = context.Addresses.Select(a => new
            {
                Text = a.AddressText,
                Town = a.Town!.Name,
                Count = a.Employees.Count
            }).OrderByDescending(a => a.Count).ThenBy(e => e.Town).ThenBy(e => e.Text).Take(10).ToList();
            foreach (var e in addresses)
            {
                stringBuilder.AppendLine($"{e.Text}, {e.Town} - {e.Count} employees");
            }
            return stringBuilder.ToString().TrimEnd();
        }
        public static string GetEmployee147(SoftUniContext context)
        {
            var e147 = context.Employees.Where(e => e.EmployeeId == 147)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    e.JobTitle,
                    Projects = e.EmployeesProjects.Select(e => e.Project).OrderBy(e => e.Name).ToList()
                }).FirstOrDefault();
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.AppendLine($"{e147.FirstName} {e147.LastName} - {e147.JobTitle}");
            foreach (var e in e147.Projects)
            {
                stringBuilder.AppendLine(e.Name);
            }


            return stringBuilder.ToString().TrimEnd();
        }
        public static string GetDepartmentsWithMoreThan5Employees(SoftUniContext context)
        {
            var departments = context.Departments.Select(d => new
            {
                DepartmentName = d.Name,
                MFirst = d.Manager.FirstName,
                MLast = d.Manager.LastName,
                Employees = d.Employees,
            }).Where(d => d.Employees.Count > 5)
            .OrderBy(d => d.Employees.Count).ThenBy(d => d.DepartmentName)
            .ToArray();
            StringBuilder sb = new StringBuilder();
            foreach (var department in departments)
            {
                sb.AppendLine($"{department.DepartmentName} - {department.MFirst} {department.MLast}");
                foreach (var e in department.Employees.OrderBy(e => e.FirstName).ThenBy(e => e.LastName))
                {
                    sb.AppendLine($"{e.FirstName} {e.LastName} - {e.JobTitle}");
                }
            }
            return sb.ToString().TrimEnd();
        }
        public static string GetLatestProjects(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var projects = context.Projects.OrderByDescending(p => p.StartDate).Select(p => new
            {
                p.Name,
                p.Description,
                p.StartDate
            }).Take(10).OrderBy(p => p.Name).ToArray();
            foreach (var p in projects)
            {
                sb.AppendLine(p.Name);
                sb.AppendLine(p.Description);
                sb.AppendLine(p.StartDate.ToString());
            }
            return sb.ToString().TrimEnd();
        }
        public static string IncreaseSalaries(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var employees = context.Employees.
                Where(d => d.Department.Name == "Engineering"
                || d.Department.Name == "Tool Design" || d.Department.Name == "Marketing" ||
                d.Department.Name == "Information Services").OrderBy(e=>e.FirstName).ThenBy(e => e.LastName).ToList();
            foreach (var employee in employees) 
            {
                employee.Salary *=1.12M;
                sb.AppendLine($"{employee.FirstName} {employee.LastName} (${employee.Salary:F2})");
            }
            context.SaveChanges();
            return sb.ToString().TrimEnd();
        }
        public static string GetEmployeesByFirstNameStartingWithSa(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var employees=context.Employees.Where(e=>e.FirstName.StartsWith("Sa")).Select(e => new
            {
                e.FirstName,
                e.LastName,
                e.JobTitle,
                e.Salary
            }).OrderBy(e=>e.FirstName).ThenBy(e=>e.LastName).ToList();
            foreach (var employee in employees)
            {
                sb.AppendLine($"{employee.FirstName} {employee.LastName} - {employee.JobTitle} - (${employee.Salary:F2})");
            }
            return sb.ToString().TrimEnd();
        }
        public static string DeleteProjectById(SoftUniContext context)
        {
            const int deleteProjectId = 2;

            var employeeProjectsDelete = context.EmployeesProjects
                .Where(ep => ep.ProjectId == deleteProjectId)
                .ToList();

            context.EmployeesProjects.RemoveRange(employeeProjectsDelete);

            var deleteProject = context.Projects.Find(deleteProjectId);

            if (deleteProject != null)
            {
                context.Projects.Remove(deleteProject);
            }

            context.SaveChanges();

            string[] projectNames = context.Projects
                .Select(p => p.Name)
                .Take(10)
                .ToArray();

            return string.Join(Environment.NewLine, projectNames);
        }
        public static string RemoveTown(SoftUniContext context)
        {
            var town = context.Towns
                .Include(t => t.Addresses)
                .FirstOrDefault(t => t.Name == "Seattle");

            var employees = context.Employees
                .Where(e => e.Address!.Town!.Name == "Seattle");
            foreach (var e in employees)
            {
                e.AddressId = null;
            }
            context.Addresses.RemoveRange(town!.Addresses);
            context.Towns.Remove(town);
            context.SaveChanges();

            return $"{town.Addresses.Count} addresses in Seattle were deleted";
        }
    }
}
