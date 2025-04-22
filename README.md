# 🧼 Fully Automatic Washing Machine (Verilog-based FSM)

Hi 👋, I'm Sahil Kumar — B.Tech Electronics and Communication Engineering (IoT) undergraduate at IIIT Nagpur and a Smart India Hackathon 2024 winner. This project demonstrates a complete FSM-based control system for a fully automatic washing machine using Verilog HDL and implemented on the DE10-Lite FPGA board.

---

## 📌 Project Overview

This project simulates the internal control mechanism of a washing machine using a Finite State Machine (FSM) written in Verilog. It handles various user inputs like start, cancel, lid open, and coin insertion, and operates different modes depending on the cloth weight selected. The system controls all phases of washing: Soak, Wash, Rinse, and Spin.

---

## ⚙️ Features & Functionality

- ⏱️ Mode-Based Operation (3 modes based on cloth weight)
- 🔄 FSM-based sequencing (IDLE → READY → SOAK → WASH → RINSE → SPIN)
- 🛑 Lid Safety Interruption
- ⏳ Timers for each phase
- 💰 Coin Input and Cancel Handling
- 🔢 Seven-Segment Display Output for State Monitoring
- 💧 Water Inlet Control & Coin Return Mechanism

---

## 🧠 FSM States

- IDLE: Waiting for user action
- READY: After coin is inserted
- SOAK, WASH, RINSE, SPIN: Sequential wash operations with timers
- Each state is controlled using a clock-driven FSM

---

## 🔍 Inputs & Outputs

| Input Signal     | Description                       |
|------------------|-----------------------------------|
| i_clk            | Clock Signal (50 MHz)             |
| i_lid            | Lid Status                        |
| i_start          | Start Button                      |
| i_cancel         | Cancel Button                     |
| i_coin           | Coin Inserted                     |
| i_mode_1/2/3     | Mode Select (based on weight)     |

| Output Signal    | Description                        |
|------------------|------------------------------------|
| o_idle           | IDLE state indicator               |
| o_ready          | READY state indicator              |
| o_soak           | SOAK phase indicator               |
| o_wash           | WASH phase indicator               |
| o_rinse          | RINSE phase indicator              |
| o_spin           | SPIN phase indicator               |
| o_waterinlet     | Water inlet control                |
| o_coinreturn     | Coin return if cancelled           |
| o_done           | Indicates wash cycle is complete   |
| hex0 to hex5     | 7-Segment Display for current state|

---

## 🛠 Technologies Used

- Verilog HDL
- DE10-Lite FPGA Board (Intel MAX10)
- Intel Quartus Prime
- FSM (Finite State Machine) Design
- Seven Segment Display Encoding

---

## 📸 Demo & Flowchart

📷 Flowchart & simulation screenshots can be added here (if available).

---

## 🧾 References

- Terasic DE10-Lite Board: https://www.mouser.in/new/terasic-technologies/terasic-de10-lite-board/  
- GitHub Inspiration: https://github.com/mnmhdanas/Automatic-washing-machine  

---

## 👨‍💻 Author

Sahil Kumar  
📧 sahilchoudharyaa9480@gmail.com  
🔗 LinkedIn: https://linkedin.com/in/sahil9480  
🏫 IIIT Nagpur | ECE (IoT)  

Feel free to ⭐ this repository if you found it helpful!
