using Newtonsoft.Json;
using SocialNetwork.Data;
using SocialNetwork.Data.Models;
using SocialNetwork.Data.Models.Enums;
using SocialNetwork.DataProcessor.ImportDTOs;
using SocialNetwork.Utilities;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Text;

namespace SocialNetwork.DataProcessor
{
    public class Deserializer
    {
        private const string ErrorMessage = "Invalid data format.";
        private const string DuplicatedDataMessage = "Duplicated data.";
        private const string SuccessfullyImportedMessageEntity = "Successfully imported message (Sent at: {0}, Status: {1})";
        private const string SuccessfullyImportedPostEntity = "Successfully imported post (Creator {0}, Created at: {1})";

        public static string ImportMessages(SocialNetworkDbContext dbContext, string xmlString)
        {
            StringBuilder sb = new StringBuilder();

            ImportMessageDto[]? messageDtos = XmlHelper
                .Deserialize<ImportMessageDto[]>(xmlString, "Messages");

            if (messageDtos!=null && messageDtos.Length>0)
            {
                ICollection<Message> validMessages = new List<Message>();

                foreach (ImportMessageDto messageDto in messageDtos)
                {
                    if (!IsValid(messageDto))
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }

                    bool isDateValid = DateTime
                        .TryParseExact(messageDto.SentAt, "yyyy-MM-ddTHH:mm:ss"
                        , CultureInfo.InvariantCulture,DateTimeStyles.None, out DateTime sentAt);
                    if (!isDateValid) 
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }

                    bool isStatusValid = Enum
                        .TryParse<MessageStatus>(messageDto.Status,out MessageStatus status);

                    if (!isStatusValid)
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }

                    if (!dbContext.Conversations.Any(m=>m.Id==messageDto.ConversationId))
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }
                    if(!dbContext.Users.Any(u => u.Id == messageDto.SenderId))
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }

                    bool isConversationStuffDuplicated=dbContext.Conversations
                        .Any(c => c.Messages.Any(m => m.Status == status && m.SentAt == sentAt
                        && m.Content == messageDto.Content && m.SenderId == messageDto.SenderId));

                    bool isValidConversationStuffDuplicated=validMessages
                        .Where(m=>m.ConversationId==messageDto.ConversationId).Any(m => m.Status == status && m.SentAt == sentAt
                        && m.Content == messageDto.Content && m.SenderId == messageDto.SenderId);

                    if(isConversationStuffDuplicated || isValidConversationStuffDuplicated)
                    {
                        sb.AppendLine(DuplicatedDataMessage);
                        continue;
                    }
                    Message message = new Message
                    {
                        Content = messageDto.Content,
                        SentAt = sentAt,
                        Status = status,
                        ConversationId = messageDto.ConversationId,
                        SenderId = messageDto.SenderId
                    };
                    validMessages.Add(message);
                    sb.AppendLine(string.Format(SuccessfullyImportedMessageEntity
                        , sentAt.ToString("yyyy-MM-ddTHH:mm:ss"), status));
                }
                dbContext.Messages.AddRange(validMessages);
                dbContext.SaveChanges();
            }
            return sb.ToString().TrimEnd();
        }

        public static string ImportPosts(SocialNetworkDbContext dbContext, string jsonString)
        {
            StringBuilder sb = new StringBuilder();
            ImportPostDto[]? postDtos = JsonConvert
                .DeserializeObject<ImportPostDto[]>(jsonString);
            if (postDtos != null && postDtos.Length > 0)
            {
                ICollection<Post> validPosts = new List<Post>();
                foreach (var postDto in postDtos)
                {
                    if (!(IsValid(postDto)))
                    {
                        sb.
                            AppendLine(ErrorMessage);
                        continue;
                    }
                    bool isDateValid = DateTime
                        .TryParseExact(postDto.CreatedAt, "yyyy-MM-ddTHH:mm:ss"
                        , CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime createdAt);
                    if (!isDateValid)
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }
                    bool isCreatorIdValid = int.TryParse(postDto.CreatorId, out int creatorId);
                    if (!isCreatorIdValid)
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }
                    if (!dbContext.Users.Any(u => u.Id == creatorId))
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }
                    bool isPostDuplicated = dbContext.Posts
                        .Any(p => p.Content == postDto.Content && 
                        p.CreatedAt == createdAt && p.CreatorId==creatorId);
                    bool isValidPostDuplicated = validPosts
                        .Any(p => p.Content == postDto.Content &&
                        p.CreatedAt == createdAt && p.CreatorId == creatorId);
                    if (isPostDuplicated || isValidPostDuplicated)
                    {
                        sb.AppendLine(DuplicatedDataMessage);
                        continue;
                    }
                    Post post = new Post
                    {
                        Content = postDto.Content,
                        CreatedAt = createdAt,
                        CreatorId = creatorId
                    };
                    validPosts.Add(post);
                    sb.AppendLine(string.Format(SuccessfullyImportedPostEntity
                        , dbContext.Users.Find(creatorId).Username, createdAt.ToString("yyyy-MM-ddTHH:mm:ss")));
                }
                dbContext.Posts.AddRange(validPosts);
                dbContext.SaveChanges();
            }
            return sb.ToString().TrimEnd();
        }

        public static bool IsValid(object dto)
        {
            ValidationContext validationContext = new ValidationContext(dto);
            List<ValidationResult> validationResults = new List<ValidationResult>();

            bool isValid = Validator.TryValidateObject(dto, validationContext, validationResults, true);

            foreach (ValidationResult validationResult in validationResults)
            {
                if (validationResult.ErrorMessage != null)
                {
                    string currentMessage = validationResult.ErrorMessage;
                }
            }

            return isValid;
        }
    }
}
