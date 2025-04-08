using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SocialNetwork.Data.Models
{
    public class User
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(20)]
        public string Username { get; set; }=null!;

        [Required]
        [MaxLength(60)]
        public string Email { get; set; } = null!;

        [Required]
        public string Password { get; set; } = null!;

        [InverseProperty(nameof(Friendship.UserOne))]
        public virtual HashSet<Friendship> UserOneFriendships { get; set; } 
            = new HashSet<Friendship>();

        [InverseProperty(nameof(Friendship.UserTwo))]
        public virtual HashSet<Friendship> UserTwoFriendships { get; set; }
            = new HashSet<Friendship>();

        public virtual HashSet<Post> Posts { get; set; } 
            = new HashSet<Post>();

        public virtual HashSet<Message> Messages { get; set; }
            = new HashSet<Message>();

        public virtual HashSet<UserConversation> UsersConversations { get; set; }
            = new HashSet<UserConversation>();
    }
}
