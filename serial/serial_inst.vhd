	component serial is
		port (
			sysclk        : in    std_logic                    := 'X';             -- clk
			nreset        : in    std_logic                    := 'X';             -- reset_n
			mosi          : in    std_logic                    := 'X';             -- mosi
			nss           : in    std_logic                    := 'X';             -- nss
			miso          : inout std_logic                    := 'X';             -- miso
			sclk          : in    std_logic                    := 'X';             -- sclk
			stsourceready : in    std_logic                    := 'X';             -- ready
			stsourcevalid : out   std_logic;                                       -- valid
			stsourcedata  : out   std_logic_vector(7 downto 0);                    -- data
			stsinkvalid   : in    std_logic                    := 'X';             -- valid
			stsinkdata    : in    std_logic_vector(7 downto 0) := (others => 'X'); -- data
			stsinkready   : out   std_logic                                        -- ready
		);
	end component serial;

	u0 : component serial
		port map (
			sysclk        => CONNECTED_TO_sysclk,        --              clock_sink.clk
			nreset        => CONNECTED_TO_nreset,        --        clock_sink_reset.reset_n
			mosi          => CONNECTED_TO_mosi,          --                export_0.mosi
			nss           => CONNECTED_TO_nss,           --                        .nss
			miso          => CONNECTED_TO_miso,          --                        .miso
			sclk          => CONNECTED_TO_sclk,          --                        .sclk
			stsourceready => CONNECTED_TO_stsourceready, -- avalon_streaming_source.ready
			stsourcevalid => CONNECTED_TO_stsourcevalid, --                        .valid
			stsourcedata  => CONNECTED_TO_stsourcedata,  --                        .data
			stsinkvalid   => CONNECTED_TO_stsinkvalid,   --   avalon_streaming_sink.valid
			stsinkdata    => CONNECTED_TO_stsinkdata,    --                        .data
			stsinkready   => CONNECTED_TO_stsinkready    --                        .ready
		);

