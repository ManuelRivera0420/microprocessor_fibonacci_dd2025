module control_unit_tb ();

	// XCELIUM WFS
 	initial begin
		$shm_open("shm_db");
		$shm_probe("ASMTR");
  end

endmodule
