﻿using SocialNetwork.Data.Models.Enums;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SocialNetwork.Data.Models
{
    public class Message
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(200)]
        public string Content { get; set; } = null!;

        [Required]
        public DateTime SentAt { get; set; }

        [Required]
        public MessageStatus Status  { get; set; }

        [Required]
        [ForeignKey(nameof(Conversation))]
        public int ConversationId { get; set; }
        public Conversation Conversation { get; set; } = null!;

        [Required]
        [ForeignKey(nameof(Sender))]
        public int SenderId { get; set; }
        public User Sender { get; set; } = null!;
    }
}
