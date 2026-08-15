# UVM Register Verification Environment

A SystemVerilog verification environment built using the Universal Verification Methodology (UVM 1.2 / IEEE 1800.2). This project demonstrates core TLM (Transaction-Level Modeling) principles, component phase management, active stimulus generation, and passive monitoring.

---

## 📌 Architecture & Components

* **`reg_transaction`**: Custom `uvm_sequence_item` containing parameterized 32-bit `addr` and `data` fields with field automation macros.
* **`reg_sequence`**: Generates and randomizes register transactions to drive stimulus.
* **`reg_driver`**: Active component that pulls sequence items using the standard UVM handshake protocol (`get_next_item` and `item_done`).
* **`reg_monitor`**: Passive component that independently samples randomized bus transactions every 10 time units and broadcasts them via a `uvm_analysis_port`.
* **`reg_test`**: Top-level UVM test managing component instantiation (`build_phase`), TLM port connections (`connect_phase`), and phase objection lifecycles (`run_phase`).

---

## 🚀 How to Run

### Online via EDA Playground
You can run and simulate this testbench online directly on [EDA Playground](https://www.edaplayground.com/x/SBzX):
1. Set **Testbench + Design** to `SystemVerilog/Verilog`.
2. Set **UVM / OVM** to `UVM IEEE 1800.2-2017` (or `UVM 1.2`).
3. Select **Synopsys VCS** as the simulator.
4. Click **Run**.

### Local Command Line (Synopsys VCS)
Compile and run using VCS:

```bash
vcs -full64 -sverilog -ntb_opts uvm-1.2 design.sv testbench.sv -o simv
./simv
