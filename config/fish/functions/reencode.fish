function reencode --description "Re-encode all episodes in current directory"
    function _encoding
	set -l options 'f/files=+' 'o/outputs=+' 'c/codec=' 't/format=' 'a/audio=' 's/subs='
	argparse $options -- $argv

	set -al settings "-map"
	set -al settings "0:v"

	set -al settings "-c:v"
	set -al settings $_flag_codec

	if set --query _flag_audio
	    set -al settings (string split ' ' $_flag_audio)
	end

	if set --query _flag_subs
	    set -al settings (string split ' ' $_flag_subs)
	end

	if set --query _flag_format
	    set -al settings (string split ' ' $_flag_format)
	end
	
	for _index in (seq (count $_flag_files))
	    ffmpeg -i $_flag_files[$_index] $settings $_flag_outputs[$_index].mkv	    
	end
    end

    set --local options 'h/help' 'e/extension=' 'n/number=' 'c/codec=' 'b/bit=' 'a/audio' 's/subs' 'p/parallel='

    argparse $options -- $argv

    if set --query _flag_help
	echo "Usage: reencode [extension] [number]"
	echo "-e/--extension: Extension string"
	echo "    Example: \".mp4\""
	echo "    Default: \".mkv\""
	echo '-n/--number: A regex. the first and only group match should be the episode number'
	echo '    Example: "Bakemonogatari - (\d+) "'
	echo '    Default: ".*? (\d+)"'
	echo '-c/--codec: Video codec to encode to'
	echo '    Example: "libx265"'
	echo '    Default: "hevc_nvenc"'
	echo '-b/--bit: bit depth'
	echo '    Example: 10'
	echo '    Default: 8'
	echo '-a/--audio: audio track to maintain. if unset, keep all'
	echo '    Example: 2'
	echo '    Default: UNSET'
	echo '-s/--subs: subtitle track to maintain. if unset, keep all'
	echo '    Example: 1'
	echo '    Default: UNSET'
	echo '-p/--parallel: Number of parallel encodings when using nvenc codecs'
	echo '    Example: 4'
	echo '    Default: 2'
	return 0
    end

    set --query _flag_extension; or set --local _flag_extension ".mkv"
    set --query _flag_number;    or set --local _flag_number    ".*? (\d+)"
    set --query _flag_codec;     or set --local _flag_codec     "hevc_nvenc"
    set --query _flag_bit;       or set --local _flag_bit       8
    set --query _flag_parallel;  or set --local _flag_parallel  2

    set -l audio_string ''
    set -q _flag_audio; and set -l audio_string ' -map 0:a':$_flag_audio

    set -l subs_string ''
    set -q _flag_subs; and set -l subs_string ' -map 0:s':$_flag_subs
    
    string match -rq '_nvenc$' $_flag_codec; or set -l _flag_parallel 1

    # format string
    set -l format_string ''
    switch $_flag_codec
	case 'hevc_nvenc' 'h264_nvenc' 'h264'
	    test $_flag_bit -eq 8; and set format_string '-vf format=yuv420p'
	case 'libx265'
	    if test $_flag_bit -eq 8
		set format_string '-vf format=yuv420p'
	    else
		set format_string '-vf format=yuv420p10le'
	    end
	case '*'
	    echo "unknown codec: $_flag_codec. Ignoring bit depth" >&2
    end
    
    # Find episodes
    set -l files *$_flag_extension

    # Set episode numbers
    set -l numbers (string match -rg $_flag_number $files)

    set -l step (math 'ceil('(count $files)/$_flag_parallel')')
    for i in (seq 0 (math $_flag_parallel - 1))
	set -l istring "-f"$files[(math "$_i*$step+1")..(math "($_i + 1) * $step")]
	set -l ostring "-o"$numbers[(math "$_i*$step+1")..(math "($_i + 1) * $step")]
	_encoding -c $_flag_codec -t $format_string -a $audio_string -s $subs_string $istring $ostring &
    end
end
