{ pkgs, ... }: {
  programs.zsh.plugins = with pkgs; [
    {
      name = "forgit"; # i forgit :skull:
      file = "forgit.plugin.zsh";
      src = fetchFromGitHub {
        owner = "wfxr";
        repo = "forgit";
        rev = "99cda3248c205ba3c4638c4e461afce01a2f8acb";
        sha256 = "0jd0nl0nf7a5l5p36xnvcsj7bqgk0al2h7rdzr0m1ldbd47mxdfa";
      };
    }
    {
      name = "fast-syntax-highlighting";
      file = "fast-syntax-highlighting.plugin.zsh";
      src = fetchFromGitHub {
        owner = "zdharma-continuum";
        repo = "fast-syntax-highlighting";
        rev = "13d7b4e63468307b6dcb2dadf6150818f242cbff";
        sha256 = "0ghzqg1xfvqh9z23aga7aafrpxbp9bpy1r8vk4avi6b80p3iwsq2";
      };
    }
    {
      name = "zsh-autopair";
      file = "zsh-autopair.plugin.zsh";
      src = fetchFromGitHub {
        owner = "hlissner";
        repo = "zsh-autopair";
        rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
        sha256 = "0q9wg8jlhlz2xn08rdml6fljglqd1a2gbdp063c8b8ay24zz2w9x";
      };
    }
    {
      name = "fzf-tab";
      file = "fzf-tab.plugin.zsh";
      src = fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "5a81e13792a1eed4a03d2083771ee6e5b616b9ab";
        sha256 = "0lfl4r44ci0wflfzlzzxncrb3frnwzghll8p365ypfl0n04bkxvl";
      };
    }
    {
      name = "ctp-zsh-syntax-highlighting";
      file = "themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh";
      src = fetchFromGitHub {
        owner = "catppuccin";
        repo = "zsh-syntax-highlighting";
        rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
        sha256 = "sha256-Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
      };
    }
  ];
}

# let
#   themepkg = pkgs.fetchFromGitHub {
#     owner = "catppuccin";
#     repo = "zsh-syntax-highlighting";
#     rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
#     sha256 = "sha256-Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
#   };
