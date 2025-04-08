using Newtonsoft.Json;
using SocialNetwork.Data;
using SocialNetwork.DataProcessor.ExportDTOs;
using SocialNetwork.Utilities;

namespace SocialNetwork.DataProcessor
{
    public class Serializer
    {
        public static string ExportUsersWithFriendShipsCountAndTheirPosts(SocialNetworkDbContext dbContext)
        {
            ExportUserDto[] users=dbContext.Users
                .OrderBy(u=>u.Username)
                .Select(u=>new ExportUserDto
                {
                    Username = u.Username,
                    Posts = u.Posts.OrderBy(p=>p.Id)
                    .Select(p => new ExportPostDto
                    {
                        Content = p.Content,
                        CreatedAt = p.CreatedAt
                    }).ToArray(),
                    Friendships=u.UserOneFriendships.Count + u.UserTwoFriendships.Count
                })
                .ToArray();
            string result=XmlHelper.Serialize(users, "Users");
            return result;
        }

        public static string ExportConversationsWithMessagesChronologically(SocialNetworkDbContext dbContext)
        {
            var conversations=dbContext.Conversations
                .OrderBy(c=>c.StartedAt)
                .Select(c => new
                {
                    Id= c.Id,
                    Title=c.Title,
                    StartedAt=c.StartedAt.ToString("yyyy-MM-ddTHH:mm:ss"),
                    Messages = c.Messages.OrderBy(m=>m.SentAt)
                        .Select(m => new
                        {
                            Content = m.Content,
                            SentAt = m.SentAt.ToString("yyyy-MM-ddTHH:mm:ss"),
                            Status=((int)m.Status),
                            SenderUsername = m.Sender.Username
                        }).ToArray()
                })
                .ToArray();

            string result = JsonConvert
                .SerializeObject(conversations, Formatting.Indented);
            return result;

        }
    }
}
