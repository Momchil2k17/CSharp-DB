namespace MusicHub
{
    using System;
    using System.Text;
    using Data;
    using Initializer;
    using MusicHub.Data.Models;

    public class StartUp
    {
        public static void Main()
        {

            MusicHubDbContext context =
                new MusicHubDbContext();
            Console.WriteLine(ExportSongsAboveDuration(context,4));

        }

        public static string ExportAlbumsInfo(MusicHubDbContext context, int producerId)
        {
            StringBuilder sb = new StringBuilder();
            var albums = context.Albums.Where(x => x.ProducerId == producerId)
                .Select(a => new
                {
                    AlbumName = a.Name,
                    ReleaseDate = a.ReleaseDate,
                    ProducerName = a.Producer.Name,
                    Songs = a.Songs.Select(s => new
                    {
                        SongName = s.Name,
                        Price = s.Price,
                        Writer = s.Writer.Name
                    }).OrderByDescending(s => s.SongName).ThenBy(s => s.Writer).ToList(),
                    AlbumPrice = a.Price })
                .ToList();
            albums = albums.OrderByDescending(a => a.AlbumPrice).ToList();
            foreach (var album in albums)
            {
                sb.AppendLine($"-AlbumName: {album.AlbumName}");
                sb.AppendLine($"-ReleaseDate: {album.ReleaseDate.ToString("MM/dd/yyyy")}");
                sb.AppendLine($"-ProducerName: {album.ProducerName}");
                sb.AppendLine($"-Songs:");
                int counter = 1;
                foreach (var song in album.Songs)
                {
                    sb.AppendLine($"---#{counter}");
                    sb.AppendLine($"---SongName: {song.SongName}");
                    sb.AppendLine($"---Price: {song.Price:F2}");
                    sb.AppendLine($"---Writer: {song.Writer}");
                    counter++;
                }
                sb.AppendLine($"-AlbumPrice: {album.AlbumPrice:F2}");
            }
            return sb.ToString().TrimEnd();
        }

        public static string ExportSongsAboveDuration(MusicHubDbContext context, int duration)
        {
            var sb = new StringBuilder();
            var songs = context.Songs.Select(s => new
            {
                SongName=s.Name,
                Writer = s.Writer.Name,
                Performers=s.SongPerformers.Select(sp=>sp.Performer).ToList(),
                AlbumProducer=s.Album.Producer.Name,
                Duration=s.Duration,
            }).OrderBy(s=>s.SongName).ThenBy(s=>s.Writer).ToList();
            songs = songs.Where(s => s.Duration.TotalSeconds > duration).ToList();

            int counter = 1;
            foreach (var song in songs) 
            {
                sb.AppendLine($"-Song #{counter}");
                sb.AppendLine($"---SongName: {song.SongName}");
                sb.AppendLine($"---Writer: {song.Writer}");
                if (song.Performers.Count > 0)
                {
                    foreach (var performer in song.Performers.OrderBy(p=>p.FirstName))
                    {
                        sb.AppendLine($"---Performer: {performer.FirstName} {performer.LastName}");
                    }
                }
                sb.AppendLine($"---AlbumProducer: {song.AlbumProducer}");
                sb.AppendLine($"---Duration: {song.Duration.ToString("c")}");
                counter++;
            }
            return sb.ToString().TrimEnd();
        }
    }
}
