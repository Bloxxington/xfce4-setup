#!/usr/bin/env bash
set -e
sudo pacman -Syu --noconfirm --needed git base-devel xfconf
rm -rf /tmp/yay-bin && git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && cd /tmp/yay-bin && makepkg -si --noconfirm && cd - >/dev/null
yay -S --noconfirm --needed kitty fastfetch ttf-jetbrains-mono picom-ibhagwan-git
mkdir -p ~/.config/{kitty,picom,autostart}
printf "font_family JetBrains Mono\nfont_size 11\n" > ~/.config/kitty/kitty.conf
grep -q "KITTY_WINDOW_ID" ~/.bashrc || printf "\nif [ -n \"\$KITTY_WINDOW_ID\" ]; then fastfetch; fi\n" >> ~/.bashrc
printf "backend = \"glx\";\nvsync = true;\ndetect-client-opacity = true;\ncorner-radius = 16;\nround-borders = 1;\nrounded-corners-exclude = [];\nshadow = true;\nshadow-radius = 12;\nshadow-opacity = 0.3;\nfading = true;\nfade-in-step = 0.03;\nfade-out-step = 0.03;\nactive-opacity = 0.95;\ninactive-opacity = 0.85;\nopacity-rule = [ \"90:class_g = 'kitty'\" ];\nblur: { method = \"dual_kawase\", strength = 8, background = true, background-frame = 0 };\n" > ~/.config/picom/picom.conf
printf "[Desktop Entry]\nType=Application\nName=picom\nExec=picom --experimental-backends --config %h/.config/picom/picom.conf\nOnlyShowIn=XFCE;\nX-GNOME-Autostart-enabled=true\n" > ~/.config/autostart/picom.desktop
xfconf-query -c xfwm4 -p /general/use_compositing -s false || true
sudo systemctl restart lightdm
