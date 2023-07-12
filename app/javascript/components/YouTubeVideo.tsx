type Props = {
  id: string;
};

export const YouTubeVideo = ({ id }: Props) => {
  return (
    <div className="embed-container">
      <iframe
        width="560"
        height="315"
        src={`https://www.youtube-nocookie.com/embed/${id}`}
        title="YouTube video player"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowFullScreen
      ></iframe>
    </div>
  );
};
