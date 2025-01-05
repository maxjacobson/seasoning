type Props = {
  url: string;
};

export const MoreInfo = ({ url }: Props) => {
  return (
    <a href={url} target="_blank" rel="noreferrer" className="my-3 inline-block">
      More info ↗️
    </a>
  );
};
