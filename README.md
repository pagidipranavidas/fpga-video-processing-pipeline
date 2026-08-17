# FPGA-Based 1280×720p Video Processing Pipeline

## Overview

This project implements and verifies an FPGA-based video processing pipeline using AMD/Xilinx Vivado IP cores and AXI4-Stream interfaces.

The design generates a 1280×720 video test pattern using the Video Test Pattern Generator (TPG), transfers the video through an AXI4-Stream interface, generates the required video timing using the Video Timing Controller (VTC), and converts the AXI4-Stream video into native video output using the AXI4-Stream to Video Out IP.

The complete design was integrated using Vivado IP Integrator and functionally verified through RTL simulation and waveform analysis.

---

## Objectives

* Build an FPGA-based video pipeline using AMD/Xilinx video IP cores.
* Configure and integrate AXI4-Lite controlled video IPs.
* Generate 1280×720 video using the Video Test Pattern Generator.
* Generate synchronized video timing using the Video Timing Controller.
* Transfer video data using AXI4-Stream.
* Convert AXI4-Stream video into native video output.
* Verify AXI4-Stream handshake and native video timing through simulation.
* Configure the pixel clock to achieve the required 60 FPS frame rate.

---

## Block Diagram

[Block Diagram]

The main data and control flow is:

```text
                       AXI4-Lite Control
                              │
                              ▼
                    ┌───────────────────┐
                    │  AXI Interconnect │
                    └───────┬─────┬─────┘
                            │     │
                       Control   Control
                            │     │
                       ┌────▼┐   ┌▼────┐
                       │ VTC │   │ TPG │
                       └──┬──┘   └─┬───┘
                          │        │
                          │   AXI4-Stream
                          │        │
                          │        ▼
                          │  ┌───────────────┐
                          └─►│ AXI4-Stream   │
                             │  to Video Out │
                             └───────┬───────┘
                                     │
                                     ▼
                              Native Video Out


The AXI Traffic Generator is used as the AXI4-Lite master to configure the VTC and TPG through the AXI Interconnect.
```
---

## Main IP Cores

| IP Core                            | Purpose                                                  |
| ---------------------------------- | -------------------------------------------------------- |
| Clock Wizard                       | Generates the required internal video/system clock       |
| Processor System Reset             | Generates synchronized reset signals                     |
| AXI Traffic Generator              | Performs AXI4-Lite control transactions                  |
| AXI Interconnect                   | Connects the AXI Traffic Generator to the controlled IPs |
| Video Timing Controller (VTC)      | Generates video timing signals                           |
| Video Test Pattern Generator (TPG) | Generates test-pattern pixel data over AXI4-Stream       |
| AXI4-Stream to Video Out           | Converts AXI4-Stream video into native video output      |

---

## Video Configuration

| Parameter              | Configuration |
| ---------------------- | ------------: |
| Resolution             |    1280 × 720 |
| Active Width           |   1280 pixels |
| Active Height          |     720 lines |
| Pixel Data Width       |       24 bits |
| Target Frame Rate      |        60 FPS |
| Pixel Clock            |     74.25 MHz |
| AXI/System Clock       |       100 MHz |
| Horizontal Front Porch |           110 |
| Horizontal Sync        |            40 |
| Horizontal Back Porch  |           220 |
| Horizontal Total       |          1650 |
| Vertical Front Porch   |             5 |
| Vertical Sync          |             5 |
| Vertical Back Porch    |            20 |
| Vertical Total         |           750 |

The 24-bit video data represents three 8-bit color components.

---

## AXI4-Stream Video Interface

The TPG generates video data using an AXI4-Stream interface.

The following signals are used for the video stream:

* TDATA[23:0] — 24-bit pixel data
* TVALID — Indicates valid video data
* TREADY — Indicates that the downstream block can accept data
* TUSER — Used for Start-of-Frame (SOF)
* TLAST — Used to indicate the end of a video line

The AXI4-Stream output from the TPG is connected to the AXI4-Stream input of the AXI4-Stream to Video Out IP.

---

## AXI4-Lite Control Path

The Video Timing Controller and Video Test Pattern Generator are configured through their AXI4-Lite control interfaces.

The AXI Traffic Generator acts as the AXI4-Lite master.

```text
AXI Traffic Generator
          │
          │ AXI4-Lite
          ▼
   AXI Interconnect
       ┌──┴──┐
       │     │
       ▼     ▼
      VTC    TPG
```

The AXI Traffic Generator uses COE initialization files containing the address and data sequences required for the configuration transactions.

### Configuration Files

text
config/
├── axi_traffic_gen_address.coe
└── axi_traffic_gen_data.coe


The address and data COE files are used to initialize the AXI Traffic Generator transaction sequences.

---

## Clocking

The external input clock to the design is:

text
Input clock = 100 MHz

The Clock Wizard generates the clock used by the AXI and video-processing IPs.

The final video configuration uses:
text
Pixel/System clock = 74.25 MHz

This clock is selected to match the required 1280×720 video timing and 60 FPS frame rate.

---

## Frame Rate Optimization

During initial simulation, the pipeline was operated with a 100 MHz video clock.

The observed frame period was approximately:

text
Frame period ≈ 12.375 ms
Therefore:
text
FPS = 1000 / 12.375
    ≈ 80.8 FPS

Although the video timing signals were functioning, this did not correspond to the required 60 FPS operation.

The clock configuration was subsequently changed to:
text
Pixel clock = 74.25 MHz
With the selected 1280×720 timing parameters:
text
Horizontal total = 1650 pixels
Vertical total   = 750 lines

the required pixel clock is:
text
74.25 MHz
which results in:
text
Frame rate = 74.25 MHz / (1650 × 750)
           = 60 FPS
Thus, the final configuration achieves the required **1280×720 @ 60 FPS** operation.

---

## RTL Simulation

A Verilog testbench was created for the generated HDL wrapper.

### Testbench Configuration
text
Clock frequency : 100 MHz
Clock period    : 10 ns
Reset duration  : 100 clock cycles
Simulation time : 150 ms

The 100 MHz clock is generated using:

verilog
forever #5 clk_100MHz = ~clk_100MHz
The reset is initially asserted and released after 100 positive clock edges.

The extended simulation duration allows the video pipeline to initialize and provides sufficient time to observe multiple video frames and the final native-video output.

---

## Verification

The design was verified using Vivado RTL simulation and waveform analysis.

### AXI4-Stream Signals

The following signals were monitored:

* m_axis_video_TDATA[23:0]
* m_axis_video_TVALID
* m_axis_video_TREADY
* m_axis_video_TUSER
* m_axis_video_TLAST

### Native Video Signals

The final video output was verified using:

* vid_data[23:0]
* vid_active_video
* vid_hsync
* vid_vsync
* vid_hblank
* vid_vblank

### VTC Signals

The generated video timing was also observed through:

* vtg_active_video`
* vtg_hsync`
* vtg_vsync`
* vtg_hblank`
* vtg_vblank`
* locked

---

## Simulation Results

### AXI4-Stream and Video Output

[AXI4-Stream and Video Output Waveform]

The waveform demonstrates the relationship between the AXI4-Stream video signals and the generated native-video timing signals.

The AXI4-Stream interface shows valid pixel data with TVALID and TREADY asserted, while TUSER and TLAST provide frame and line boundary information.

---

### Native Video Output

[Video Output Waveform]

The native-video output signals including active video, horizontal synchronization, vertical synchronization, horizontal blanking, and vertical blanking are monitored during simulation.

---

### 1280×720 @ 60 FPS

[1280×720 60 FPS Waveform]

The final configuration uses a 74.25 MHz video clock and produces the expected 1280×720 video timing at approximately 60 frames per second.

The TPG-generated pixel data propagates through the AXI4-Stream interface and appears at the native-video output.

---

## Repository Structure

```text
fpga-video-processing-pipeline/
│
├── README.md
│
├── rtl/
│   ├── design_1.v
│   └── design_1_wrapper.v
│
├── simulation/
│   └── design_1_wrapper_tb.v
│
├── config/
│   ├── axi_traffic_gen_address.coe
│   └── axi_traffic_gen_data.coe
│
└── docs/
    ├── block-diagram.png
    ├── axi4-stream-video-output-waveform.png
    ├── video-output-waveform.png
    └── 1280x720-60fps-waveform.png
```
---

## Tools and Technologies

* AMD/Xilinx Vivado 2023.2
* Verilog HDL
* AXI4-Stream
* AXI4-Lite
* AXI Interconnect
* AXI Traffic Generator
* Video Timing Controller (VTC)
* Video Test Pattern Generator (TPG)
* AXI4-Stream to Video Out
* RTL Simulation
* Waveform Analysis

---

## Key Learning Outcomes

Through this project, the following concepts were studied and applied:

* AXI4-Stream video protocol
* AXI4-Lite control interfaces
* Video timing generation
* Front porch, sync, back porch, and total frame timing
* TPG configuration
* VTC configuration
* AXI IP integration using Vivado IP Integrator
* AXI4-Stream handshake verification
* Native video interface signals
* Clock configuration for a target frame rate
* HDL wrapper generation
* RTL simulation and waveform-based debugging

---

## Future Improvements

Possible extensions of the pipeline include:

* Adding additional video processing IPs
* Introducing a separate AXI and pixel clock domain
* Adding an AXI4-Stream Clock Converter for CDC
* Integrating AXI VDMA for frame-buffer based video processing
* Integrating additional video processing blocks such as VPSS, Chroma Resampler, or Color Space Conversion

---

## Author

**Pranavi Pagidi**

FPGA Design & Verification Intern
HTIC, IIT Madras Research Park

GitHub: [pagidipranavidas](https://github.com/pagidipranavidas)

LinkedIn: [pagidi pranavi](https://www.linkedin.com/in/pagidi-pranavi-a00b77280)
