using Microsoft.AspNetCore.Mvc.ModelBinding;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EDC_API.Models
{
    public class ProductionDataRequest
    {
        [JsonIgnore]
        public int Id { get; set; }
        [Required]
        public string Wellbore { get; set; }
        public int Year { get; set; }
        [Range(1, 12)]
        public int Month { get; set; }
        public decimal Oil { get; set; }
        public decimal Gas { get; set; }
    }
}
