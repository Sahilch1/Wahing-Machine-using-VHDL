`timescale 1ms / 1ms

// Washing Machine FSM Controller Module
t
module washingmachine(
    i_clk, i_lid, i_start, i_cancel, i_coin,
    i_mode_1, i_mode_2, i_mode_3,
    o_idle, o_ready, o_soak, o_wash, o_rinse, o_spin,
    o_coinreturn, o_waterinlet, o_done,
    hex0, hex1, hex2, hex3, hex4, hex5
);

// Input declarations
input i_clk, i_start, i_cancel, i_coin, i_lid, i_mode_1, i_mode_2, i_mode_3;

// Output declarations
output o_idle, o_ready, o_soak, o_wash, o_rinse, o_spin, o_waterinlet;
output o_coinreturn, o_done;
output reg [0:6] hex0, hex1, hex2, hex3, hex4, hex5;

// State encoding
parameter IDLE = 6'b000001,
          READY = 6'b000010,
          SOAK = 6'b000100,
          WASH = 6'b001000,
          RINSE = 6'b010000,
          SPIN = 6'b100000;

// FSM state registers
reg [5:0] PS, NS;

// Operation completion flags
reg soak_done, wash_done, rinse_done, spin_done;

// Operation trigger and pause control signals
wire soak_up, wash_up, rinse_up, spin_up;
wire soak_pause, wash_pause, rinse_pause, spin_pause;

// Counters for each wash stage
reg [30:0] soakcounter, washcounter, rinsecounter, spincounter;

// Pause timers if lid is open during active stages
assign soak_pause = (PS == SOAK) && i_lid;
assign wash_pause = (PS == WASH) && i_lid;
assign rinse_pause = (PS == RINSE) && i_lid;
assign spin_pause = (PS == SPIN) && i_lid;

// Activation conditions
assign soak_up = (PS == SOAK) && (i_mode_1 || i_mode_2 || i_mode_3);
assign wash_up = (PS == WASH);
assign rinse_up = (PS == RINSE);
assign spin_up = (PS == SPIN);

// Completion conditions based on mode selection
always @(i_mode_1, i_mode_2, i_mode_3, soakcounter)
begin
    if(i_mode_1)
        soak_done = (soakcounter == 100000000);
    else if(i_mode_2)
        soak_done = (soakcounter == 250000000);
    else if(i_mode_3)
        soak_done = (soakcounter == 500000000);
end

always @(i_mode_1, i_mode_2, i_mode_3, washcounter)
begin
    if(i_mode_1)
        wash_done = (washcounter == 100000000);
    else if(i_mode_2)
        wash_done = (washcounter == 250000000);
    else if(i_mode_3)
        wash_done = (washcounter == 500000000);
end

always @(i_mode_1, i_mode_2, i_mode_3, rinsecounter)
begin
    if(i_mode_1)
        rinse_done = (rinsecounter == 100000000);
    else if(i_mode_2)
        rinse_done = (rinsecounter == 250000000);
    else if(i_mode_3)
        rinse_done = (rinsecounter == 500000000);
end

always @(i_mode_1, i_mode_2, i_mode_3, spincounter)
begin
    if(i_mode_1)
        spin_done = (spincounter == 100000000);
    else if(i_mode_2)
        spin_done = (spincounter == 250000000);
    else if(i_mode_3)
        spin_done = (spincounter == 500000000);
end

// Timers for each stage
always @(posedge i_clk)
begin
    if(i_start || soak_done)
        soakcounter <= 0;
    else if(!soak_pause && soak_up)
        soakcounter <= soakcounter + 1;
end

always @(posedge i_clk)
begin
    if(i_start || wash_done)
        washcounter <= 0;
    else if(!wash_pause && wash_up)
        washcounter <= washcounter + 1;
end

always @(posedge i_clk)
begin
    if(i_start || rinse_done)
        rinsecounter <= 0;
    else if(!rinse_pause && rinse_up)
        rinsecounter <= rinsecounter + 1;
end

always @(posedge i_clk)
begin
    if(i_start || spin_done)
        spincounter <= 0;
    else if(!spin_pause && spin_up)
        spincounter <= spincounter + 1;
end

// State transition logic
always @(posedge i_clk)
begin
    if(i_start || i_cancel)
        PS <= IDLE;
    else
        PS <= NS;
end

// Next State and Display Logic
always @(*)
begin
    case (PS)
        IDLE:
begin
            {hex0, hex1, hex2, hex3, hex4, hex5} = {7'h7F, 7'h7F, 7'h30, 7'h71, 7'h42, 7'h79};
            NS = (~i_coin && !i_lid && !i_cancel) ? READY : IDLE;
        end
        READY:
begin
            {hex0, hex1, hex2, hex3, hex4, hex5} = {7'h7F, 7'h44, 7'h42, 7'h08, 7'h30, 7'h7A};
            NS = (!i_lid && !i_cancel && (i_mode_1 || i_mode_2 || i_mode_3)) ? SOAK : READY;
        end
        SOAK:
begin
            {hex0, hex1, hex2, hex3, hex4, hex5} = {7'h7F, 7'h7F, 7'h78, 7'h08, 7'h62, 7'h24};
            NS = (!i_lid && !i_cancel && soak_done) ? WASH : SOAK;
        end
        WASH:
begin
            {hex0, hex1, hex2, hex3, hex4, hex5} = {7'h7F, 7'h7F, 7'h68, 7'h24, 7'h08, 7'h61};
            NS = (!i_lid && !i_cancel && wash_done) ? RINSE : WASH;
        end
        RINSE:
begin
            {hex0, hex1, hex2, hex3, hex4, hex5} = {7'h7F, 7'h30, 7'h24, 7'h6A, 7'h79, 7'h7A};
            NS = (!i_lid && !i_cancel && rinse_done) ? SPIN : RINSE;
        end
        SPIN:
begin
            {hex0, hex1, hex2, hex3, hex4, hex5} = {7'h7F, 7'h7F, 7'h6A, 7'h79, 7'h18, 7'h24};
            NS = (!i_lid && !i_cancel && spin_done) ? IDLE : SPIN;
        end
        default: NS = IDLE;
    endcase
end

// Output logic
assign o_idle = (PS == IDLE);
assign o_ready = (PS == READY);
assign o_soak = (PS == SOAK);
assign o_wash = (PS == WASH);
assign o_rinse = (PS == RINSE);
assign o_spin = (PS == SPIN);
assign o_waterinlet = (PS == SOAK || PS == WASH || PS == RINSE);
assign o_coinreturn = (PS == READY) && i_cancel;
assign o_done = (PS == SPIN) && spin_done;

endmodule
