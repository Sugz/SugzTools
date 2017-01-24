using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;

namespace DragAndDrop
{
    public class Product
    {
        public string Name { get; set; }
        public int Qty { get; set; }
        public string Description { get; set; }
        public List<SubItem> SubItems { get; set; }

        public static ObservableCollection<Product> GetProducts()
        {
            return new ObservableCollection<Product>(new Product[] {
                    new Product { Name="Product1", Qty=10, Description="Description 1", 
                        SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem1"} }) },
                    new Product { Name="Product2", Qty=5, Description="Description 2",
                        SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem2"} })},
                    new Product { Name="Product3", Qty=15, Description="Description 3",
                        SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem3"} })},
                     new Product { Name="Product4", Qty=33, Description="Description 4",
                        SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem4"} })},
                 new Product { Name="Product5", Qty=98, Description="Description 5",
                            SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem5"} })},
                 new Product { Name="Product6", Qty=215, Description="Description 6",
                            SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem6"} })},
                 new Product { Name="Product7", Qty=25, Description="Description 7",
                            SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem7"} })},
                 new Product { Name="Product8", Qty=10, Description="Description 8",
                            SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem8"} })},
                 new Product { Name="Product9", Qty=55, Description="Description 9",
                            SubItems = new List<SubItem>(new SubItem[] { new SubItem() { Name ="SubItem9"} })}
            });
        }


    }

    public class SubItem
    {
        public string Name { get; set; }
    }
}
