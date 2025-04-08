﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace SocialNetwork.DataProcessor.ExportDTOs
{
    [XmlType("User")]
    public class ExportUserDto
    {

        [XmlElement("Username")]
        public string Username { get; set; }=null!;

        [XmlArray("Posts")]
        public ExportPostDto[] Posts { get; set; } = null!;

        [XmlAttribute("Friendships")]
        public int Friendships { get; set; }

    }
}
