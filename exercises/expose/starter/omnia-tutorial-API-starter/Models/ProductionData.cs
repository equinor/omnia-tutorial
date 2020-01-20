using Microsoft.AspNetCore.Mvc.ModelBinding;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace omnia_tutorial.Models
{
    public class ProductionData
    {
        public virtual int Id { get; set; }

        public string Wellbore { get; set; }
        public int? Year { get; set; }
        [Range(1, 12)]
        public int? Month { get; set; }
        public decimal? Oil { get; set; }
        public decimal? Gas { get; set; }
    }
}
