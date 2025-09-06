#!/bin/bash

# Install btop - A beautiful system monitor
# btop is more modern and prettier than htop

UPACK_DIR="${UPACK_DIR:-$HOME/.local/share/upack}"
source "$UPACK_DIR/utils/gum.sh" 2>/dev/null || {
    # Fallback log functions if gum.sh not available
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
} 2>/dev/null || true

# Define log functions if not already available
if ! command -v log_step &> /dev/null; then
    log_step() { echo "🔄 $1"; }
    log_info() { echo "ℹ️  $1"; }
    log_success() { echo "✅ $1"; }
    log_error() { echo "❌ $1"; }
    log_warning() { echo "⚠️  $1"; }
fi

install_btop() {
    log_step "Installing btop - Modern system monitor"
    
    if command -v btop &> /dev/null; then
        log_info "btop already installed"
        btop --version
        return 0
    fi
    
    # Try installing from repositories first
    if install_from_apt; then
        log_success "btop installed via APT"
    elif install_from_snap; then
        log_success "btop installed via Snap"
    elif install_from_source; then
        log_success "btop installed from source"
    else
        log_error "Failed to install btop"
        return 1
    fi
    
    # Configure btop
    configure_btop
    
    # Create desktop entry
    create_desktop_entry
    
    log_success "btop installation completed!"
    log_info "Launch with: btop or upack monitor"
}

install_from_apt() {
    log_info "Trying to install btop from APT repositories..."
    
    if sudo apt update && sudo apt install -y btop; then
        return 0
    else
        log_warning "btop not available in APT repositories"
        return 1
    fi
}

install_from_snap() {
    log_info "Trying to install btop from Snap..."
    
    if command -v snap &> /dev/null; then
        if sudo snap install btop; then
            return 0
        else
            log_warning "Failed to install btop via Snap"
            return 1
        fi
    else
        log_warning "Snap not available"
        return 1
    fi
}

install_from_source() {
    log_info "Installing btop from source..."
    
    # Install dependencies
    log_info "Installing build dependencies..."
    sudo apt update
    sudo apt install -y build-essential git cmake
    
    # Clone and build btop
    local build_dir="/tmp/btop-build"
    rm -rf "$build_dir"
    
    log_info "Cloning btop repository..."
    if git clone https://github.com/aristocratos/btop.git "$build_dir"; then
        cd "$build_dir"
        
        log_info "Building btop..."
        if make && sudo make install PREFIX=/usr/local; then
            cd - > /dev/null
            rm -rf "$build_dir"
            return 0
        else
            log_error "Failed to build btop"
            cd - > /dev/null
            rm -rf "$build_dir"
            return 1
        fi
    else
        log_error "Failed to clone btop repository"
        return 1
    fi
}

configure_btop() {
    log_info "Configuring btop with UPack settings..."
    
    # Create btop config directory
    mkdir -p "$HOME/.config/btop"
    
    # Create btop configuration with Nord theme
    cat > "$HOME/.config/btop/btop.conf" << 'EOF'
#? Config file for btop v. 1.3.2

#* Name of a btop++/bpytop/bashtop formatted ".theme" file, "Default" and "TTY" for builtin themes.
#* Themes should be placed in "../share/btop/themes" relative to binary or "$HOME/.config/btop/themes"
color_theme = "nord"

#* If the theme set background should be shown, set to False if you want terminal background transparency.
theme_background = True

#* Sets if 24-bit truecolor should be used, will convert 24-bit colors to 256 color (6x6x6 color cube) if false.
truecolor = True

#* Set to true to force tty mode regardless if a real tty has been detected or not.
force_tty = False

#* Define presets for the layout of the boxes. Preset 0 is always all boxes shown with default settings. Max 9 presets.
#* Format: "box_name:P:G,box_name:P:G" P=(0 or 1) for alternate positions, G=graph type, 0=default, 1=braille, 2=block, 3=tty.
#* Use withespace " " as separator between different presets.
#* Example: "cpu:0:default,mem:0:tty,net:0:tty cpu:0:braille,proc:1:default cpu:0:block,net:0:tty"
presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty"

#* Set to True to enable "h,j,k,l,g,G" keys for directional control in lists.
#* Conflicting keys for h:"help" and k:"kill" is accessible while holding shift.
vim_keys = True

#* Rounded corners on boxes, is ignored if TTY mode is ON.
rounded_corners = True

#* Default symbols to use for graph creation, "braille", "block" or "tty".
#* "braille" offers the highest resolution but might not be included in all fonts.
#* "block" has half the resolution of braille but uses more common characters.
#* "tty" uses only 3 different characters but will work on any terminal.
graph_symbol = "braille"

# Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
graph_symbol_cpu = "default"

# Graph symbol to use for graphs in mem box, "default", "braille", "block" or "tty".
graph_symbol_mem = "default"

# Graph symbol to use for graphs in net box, "default", "braille", "block" or "tty".
graph_symbol_net = "default"

# Graph symbol to use for graphs in proc box, "default", "braille", "block" or "tty".
graph_symbol_proc = "default"

#* Manually set which boxes to show. Available values are "cpu mem net proc", separate values with whitespace.
shown_boxes = "cpu mem net proc"

#* Update time in milliseconds, recommended 2000 ms or above for better sample times for graphs.
update_ms = 2000

#* Processes sorting, "pid" "program" "arguments" "threads" "user" "memory" "cpu lazy" "cpu direct",
#* "cpu lazy" sorts top process over time (easier to follow), "cpu direct" updates top process directly.
proc_sorting = "cpu lazy"

#* Reverse sorting order, True or False.
proc_reversed = False

#* Show processes as a tree.
proc_tree = False

#* Use the cpu graph colors in the process list.
proc_colors = True

#* Use a darkening gradient in the process list.
proc_gradient = True

#* If process cpu usage should be of the core it's running on or usage of the total available cpu power.
proc_per_core = False

#* Show process memory as bytes instead of percent.
proc_mem_bytes = True

#* Show cpu graph for each process.
proc_cpu_graphs = True

#* Use /proc/[pid]/smaps for memory information in the process info box (very slow but more accurate)
proc_info_smaps = False

#* Show proc box on left side of screen instead of right.
proc_left = False

#* (Linux) Filter processes tied to the Linux kernel(similar behavior to htop).
proc_filter_kernel = False

#* Sets the CPU stat shown in upper half of the CPU graph, "total" is always available.
#* Select from a list of detected attributes from the options menu.
cpu_graph_upper = "total"

#* Sets the CPU stat shown in lower half of the CPU graph, "total" is always available.
#* Select from a list of detected attributes from the options menu.
cpu_graph_lower = "total"

#* Toggles if the lower CPU graph should be inverted.
cpu_invert_lower = True

#* Set to True to completely disable the lower CPU graph.
cpu_single_graph = False

#* Show cpu box at bottom of screen instead of top.
cpu_bottom = False

#* Shows the system uptime in the CPU box.
show_uptime = True

#* Show cpu temperature.
check_temp = True

#* Which sensor to use for cpu temperature, use options menu to select from list of available sensors.
cpu_sensor = "Auto"

#* Show temperatures for cpu cores also if check_temp is True and sensors has been found.
show_coretemp = True

#* Set a custom mapping between core and coretemp, can be needed on certain cpus to get correct temperature for correct core.
#* Use lm-sensors or similar to see which cores are reporting temperatures on your machine.
#* Format "x:y" x=core, y=temp_index, separate multiple with space, ex: "0:0 1:0 2:1 3:3".
cpu_core_map = ""

#* Which temperature scale to use, available values: "celsius", "fahrenheit", "kelvin" and "rankine".
temp_scale = "celsius"

#* Use base 10 for bits/bytes sizes, KB = 1000 instead of KiB = 1024.
base_10_sizes = False

#* Show CPU frequency.
show_cpu_freq = True

#* Draw a clock at top of screen, formatting according to strftime, empty string to disable.
#* Special formatting: /host = hostname | /user = username | /uptime = system uptime
clock_format = "%X"

#* Update main ui in background when menus are showing, set this to false if the menus is flickering too much for comfort.
background_update = True

#* Custom cpu model name, empty string to disable.
custom_cpu_name = ""

#* Optional filter for shown disks, should be full path of a mountpoint, separate multiple values with whitespace " ".
#* Begin line with "exclude=" to change to exclude filter, otherwise defaults to "most include" filter. Example: disks_filter="exclude=/boot /home/user".
disks_filter = ""

#* Show graphs instead of meters for memory values.
mem_graphs = True

#* Show mem box below net box instead of above.
mem_below_net = False

#* Count ZFS ARC in cached and available memory.
zfs_arc_cached = True

#* If swap memory should be shown in memory box.
show_swap = True

#* If swap memory should be shown in percent.
swap_percent = True

#* If mem box should be split to also show disks info.
show_disks = True

#* Filter out non physical disks. Set this to False to include network disks, RAM disks and similar.
only_physical = True

#* Read disks list from /etc/fstab. This also disables only_physical.
use_fstab = True

#* Setting this to True will hide all datasets, and only show ZFS pools. (IO stats will be calculated per-pool)
zfs_hide_datasets = False

#* Set to true to show available disk space for privileged users.
disk_free_priv = False

#* Toggles if io activity % (disk busy time) should be shown in regular disk usage view.
show_io_stat = True

#* Toggles io mode for disks, showing big graphs for disk read/write speeds.
io_mode = False

#* Set to True to show combined read/write io graphs in io mode.
io_graph_combined = False

#* Set the top speed for the io graphs in MiB/s (100 by default), use format "mountpoint:speed" separate disks with whitespace " ".
#* Example: "/mnt/media:100 /:20 /boot:1".
io_graph_speeds = ""

#* Set fixed values for network graphs in Mebibits. Is only used if net_auto is also set to False.
net_download = 100

net_upload = 100

#* Use network graphs auto rescaling mode, ignores any values set above and rescales down to 10 Kibibytes at the lowest.
net_auto = True

#* Sync the auto scaling for download and upload to whichever currently has the highest scale.
net_sync = True

#* Starts with the Network Interface specified here.
net_iface = ""

#* Show battery stats in top right if battery is present.
show_battery = True

#* Which battery to use if multiple are present. "Auto" for auto detection.
selected_battery = "Auto"

#* Set loglevel for "~/.config/btop/btop.log" levels are: "ERROR" "WARNING" "INFO" "DEBUG".
#* The level set includes all lower levels, i.e. "DEBUG" will show all logging info.
log_level = "WARNING"
EOF

    # Create Nord theme for btop
    mkdir -p "$HOME/.config/btop/themes"
    
    cat > "$HOME/.config/btop/themes/nord.theme" << 'EOF'
# Nord theme for btop
# UPack customized version

# Main background, empty for terminal default, need to be empty if you want transparent background
theme[main_bg]="#2e3440"

# Main text color
theme[main_fg]="#d8dee9"

# Title color for boxes
theme[title]="#88c0d0"

# Highlight color for keyboard shortcuts
theme[hi_fg]="#81a1c1"

# Background color of selected items
theme[selected_bg]="#434c5e"

# Foreground color of selected items
theme[selected_fg]="#eceff4"

# Color of inactive/disabled text
theme[inactive_fg]="#4c566a"

# Color of text appearing on top of graphs, i.e uptime and current network graph scaling
theme[graph_text]="#d8dee9"

# Background color of the percentage meters
theme[meter_bg]="#3b4252"

# Misc colors for processes box including mini cpu graphs, details memory graph and details status text
theme[proc_misc]="#88c0d0"

# CPU, Memory, Network, Proc box outline colors
theme[cpu_box]="#88c0d0"
theme[mem_box]="#a3be8c"
theme[net_box]="#ebcb8b"
theme[proc_box]="#bf616a"

# Box divider line and small boxes line color
theme[div_line]="#4c566a"

# Temperature graph colors (main graph color first, followed by colors for incremental temp levels)
theme[temp_start]="#a3be8c"
theme[temp_mid]="#ebcb8b"
theme[temp_high]="#bf616a"

# CPU graph colors (main graph color first, followed by colors for incremental cpu percentage levels)
theme[cpu_start]="#88c0d0"
theme[cpu_mid]="#5e81ac"
theme[cpu_high]="#b48ead"

# Mem/Disk free meter
theme[free_start]="#a3be8c"
theme[free_mid]="#ebcb8b"
theme[free_end]="#bf616a"

# Mem/Disk cached meter
theme[cached_start]="#88c0d0"
theme[cached_mid]="#5e81ac"
theme[cached_end]="#b48ead"

# Mem/Disk available meter
theme[available_start]="#a3be8c"
theme[available_mid]="#ebcb8b"
theme[available_end]="#d08770"

# Mem/Disk used meter
theme[used_start]="#bf616a"
theme[used_mid]="#d08770"
theme[used_end]="#ebcb8b"

# Download graph colors
theme[download_start]="#88c0d0"
theme[download_mid]="#5e81ac"
theme[download_end]="#b48ead"

# Upload graph colors
theme[upload_start]="#a3be8c"
theme[upload_mid]="#ebcb8b"
theme[upload_end]="#d08770"

# Process box color gradient for threads, mem and cpu usage
theme[process_start]="#88c0d0"
theme[process_mid]="#5e81ac"
theme[process_end]="#b48ead"
EOF
    
    log_success "btop configured with Nord theme"
}

create_desktop_entry() {
    log_info "Creating btop desktop entry..."
    
    # Detect available terminal emulator
    local terminal_cmd=""
    local terminal_option=""
    local use_terminal_flag="false"
    
    if command -v alacritty >/dev/null 2>&1; then
        terminal_cmd="alacritty"
        terminal_option="--config-file \"$HOME/.config/alacritty/btop.toml\" --class=btop --title=\"System Monitor\" -e"
    elif command -v gnome-terminal >/dev/null 2>&1; then
        terminal_cmd="gnome-terminal"
        terminal_option="--title=\"System Monitor\" --"
    elif command -v x-terminal-emulator >/dev/null 2>&1; then
        terminal_cmd="x-terminal-emulator"
        terminal_option="-e"
    else
        # Fallback: run btop directly and let desktop handle terminal
        terminal_cmd="btop"
        terminal_option=""
        use_terminal_flag="true"
    fi
    
    # Build Exec line with resolved paths
    local exec_line=""
    if [ -n "$terminal_option" ]; then
        exec_line="$terminal_cmd $terminal_option btop"
    else
        exec_line="$terminal_cmd"
    fi
    
    # Create desktop entry for btop
    cat > "$HOME/.local/share/applications/btop.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=btop
Comment=Resource monitor that shows usage and stats
Exec=$exec_line
Terminal=$use_terminal_flag
Type=Application
Icon=utilities-system-monitor
Categories=System;Monitor;
StartupNotify=false
Keywords=system;process;task;monitor;
EOF
    
    log_success "Desktop entry created for btop with terminal: $terminal_cmd"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_btop
fi
