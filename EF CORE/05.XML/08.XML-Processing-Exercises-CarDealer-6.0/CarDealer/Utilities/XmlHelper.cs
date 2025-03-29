using CarDealer.DTOs.Import;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace CarDealer.Utilities
{
    public class XmlHelper
    {
        public static T? Deserialize<T>(string inputXml,string rootName)
            where T : class
        {
            XmlRootAttribute root = new XmlRootAttribute(rootName);
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(T), root);
            using StringReader stringReader = new StringReader(inputXml);
            object? deserializedObject = xmlSerializer
                .Deserialize(stringReader);
            if (deserializedObject == null) 
            {
                return null;
            }
            return (T)deserializedObject;
        }
        public static T? Deserialize<T>(Stream stream, string rootName)
            where T : class
        {
            XmlRootAttribute root = new XmlRootAttribute(rootName);
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(T[]), root);
            object? deserializedObject = xmlSerializer
                .Deserialize(stream);
            if (deserializedObject == null)
            {
                return null;
            }
            return (T)deserializedObject;
        }
        public static string Serialize<T>(T obj, string rootName, Dictionary<string, string>? namespaces = null)
        {
            StringBuilder result = new StringBuilder();

            XmlRootAttribute xmlRoot = new XmlRootAttribute(rootName);
            XmlSerializer xmlSerializer
                = new XmlSerializer(typeof(T), xmlRoot);
            XmlSerializerNamespaces xmlNamespaces = new XmlSerializerNamespaces();
            if (namespaces == null)
            {
                xmlNamespaces.Add(string.Empty, string.Empty);
            }
            else
            {
                foreach (KeyValuePair<string, string> kvp in namespaces)
                {
                    xmlNamespaces.Add(kvp.Key, kvp.Value);
                }
            }

            using StringWriter stringWriter = new StringWriter(result);

            xmlSerializer.Serialize(stringWriter, obj, xmlNamespaces);

            return result.ToString().TrimEnd();
        }

        public static void Serialize<T>(T obj, string rootName, Stream outputStream, Dictionary<string, string>? namespaces = null)
        {
            StringBuilder result = new StringBuilder();

            XmlRootAttribute xmlRoot = new XmlRootAttribute(rootName);
            XmlSerializer xmlSerializer
                = new XmlSerializer(typeof(T), xmlRoot);
            XmlSerializerNamespaces xmlNamespaces = new XmlSerializerNamespaces();
            if (namespaces == null)
            {
                xmlNamespaces.Add(string.Empty, string.Empty);
            }
            else
            {
                foreach (KeyValuePair<string, string> kvp in namespaces)
                {
                    xmlNamespaces.Add(kvp.Key, kvp.Value);
                }
            }

            xmlSerializer.Serialize(outputStream, obj, xmlNamespaces);
        }
    }
}
