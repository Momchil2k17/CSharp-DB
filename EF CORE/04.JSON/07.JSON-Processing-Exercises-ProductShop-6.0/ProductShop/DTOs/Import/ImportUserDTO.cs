﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProductShop.DTOs.Import
{
    public class ImportUserDTO
    {
        public string? FirstName { get; set; }
        public string LastName { get; set; } = null!;
        public string? Age { get; set; }
    }
}
