import { FunctionComponent, useContext, useEffect, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { Button } from "../components/Button";
import { Guest } from "../types";
import { SetLoadingContext } from "../contexts";
import { TextField } from "../components/TextField";

interface Props {
  setGuest: (guest: Guest) => void;
}

interface AlreadyExists {
  already_exists: true;
  email: string;
  handle: string;
  session_token: string;
  admin: boolean;
}

interface NewHuman {
  already_exists: false;
  email: string;
}

type Redemption = AlreadyExists | NewHuman;

interface LoadingMagicLink {
  loading: true;
}
interface ValidMagicLink {
  loading: false;
  email: string;
}
interface MagicLinkNotFound {
  loading: false;
  email: null;
}

type MagicLinkInfo = LoadingMagicLink | ValidMagicLink | MagicLinkNotFound;

export const RedeemMagicLinkPage: FunctionComponent<Props> = ({ setGuest }: Props) => {
  const [magicLinkInfo, setMagicLinkInfo] = useState<MagicLinkInfo>({ loading: true });
  const [handle, setHandle] = useState<string>("");
  const [creating, setCreating] = useState(false);
  const navigate = useNavigate();
  const { token } = useParams();
  const setLoading = useContext(SetLoadingContext);

  useEffect(() => {
    setLoading(true);
    (async () => {
      const response = await fetch(`/api/magic-links/${token}.json`, {
        headers: {
          "Content-Type": "application/json",
        },
      });

      setLoading(false);

      if (response.status === 404) {
        setMagicLinkInfo({ loading: false, email: null });
      } else if (!response.ok) {
        throw new Error("Could not redeem magic link");
      } else {
        const data = (await response.json()) as Redemption;

        if (data.already_exists) {
          localStorage.setItem("seasoning-guest-token", data.session_token);
          setGuest({
            authenticated: true,
            human: { handle: data.handle, admin: data.admin },
            token: data.session_token,
          });
          navigate("/");
        } else {
          setMagicLinkInfo({ loading: false, email: data.email });
        }
      }
    })();
  }, []);

  if (magicLinkInfo.loading) {
    return <div>Checking your magic link....</div>;
  }

  if (magicLinkInfo.email) {
    return (
      <div>
        <div>
          <h1 className="mb-2 text-xl">Complete your sign up</h1>
          <p className="mb-2">Just one more question... what would you like to be called?</p>

          <form
            onSubmit={async (e) => {
              e.preventDefault();

              setLoading(true);

              setCreating(true);

              const response = await fetch("/api/humans.json", {
                body: JSON.stringify({
                  humans: {
                    magic_link_token: token,
                    handle: handle,
                  },
                }),
                method: "POST",
                headers: {
                  "Content-Type": "application/json",
                },
              });

              setLoading(false);
              if (response.ok) {
                const data = (await response.json()) as AlreadyExists;

                localStorage.setItem("seasoning-guest-token", data.session_token);
                setGuest({
                  authenticated: true,
                  human: {
                    handle: data.handle,
                    admin: data.admin,
                  },
                  token: data.session_token,
                });
                navigate("/");
              } else {
                throw new Error("Could not create human");
              }
            }}
          >
            <span className="mr-2">
              <TextField
                value={handle}
                placeholder="Your handle"
                onChange={(e) => setHandle(e.target.value)}
              />
            </span>
            <Button type="submit" value="Go" disabled={creating} />
          </form>
        </div>
      </div>
    );
  } else {
    return (
      <div>
        <p>Hmmm, that magic does not seem to be valid.</p>
        <p>Perhaps it has expired.</p>
        <p>
          <Link to="/">Try again?</Link>
        </p>
      </div>
    );
  }
};
