using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SocialNetwork.Data.Models
{
    public class Friendship
    {
        //check if any error
        [Required]
        [ForeignKey(nameof(UserOne))]
        [InverseProperty(nameof(User.UserOneFriendships))]
        public int UserOneId  { get; set; }
        public User UserOne { get; set; } = null!;

        [Required]
        [ForeignKey(nameof(UserTwo))]
        [InverseProperty(nameof(User.UserTwoFriendships))]
        public int UserTwoId { get; set; }
        public User UserTwo { get; set; } = null!;
    }
}
