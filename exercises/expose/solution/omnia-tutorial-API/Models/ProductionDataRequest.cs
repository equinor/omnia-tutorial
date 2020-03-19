using Newtonsoft.Json;

namespace omnia_tutorial.Models
{
    public class ProductionDataRequest : ProductionData
    {
        [JsonIgnore]
        public override int Id { get; set; }
    }
}
