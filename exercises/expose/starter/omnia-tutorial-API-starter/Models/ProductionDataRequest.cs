using Newtonsoft.Json;
using System;
using System.ComponentModel.DataAnnotations;

namespace omnia_tutorial.Models
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
