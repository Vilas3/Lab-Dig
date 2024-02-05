/* --------------------------------------------------------------------
 * Arquivo   : circuito_exp5_tb-MODELO.vhd
 * Projeto   : Experiencia 5 - Desenvolvimento de Projeto de 
 *             Circuitos Digitais em FPGA
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog MODELO para circuito da Experiencia 5 
 *
 *             1) Plano de teste com 4 jogadas certas  
 *                e erro na quinta jogada
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     27/01/2024  1.0     Edson Midorikawa  versao inicial
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module circuito_exp5_tb_errou;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;

    wire       acertou_out;
    wire       errou_out  ;
    
    wire       pronto_out ;
    wire [3:0] leds_out   ;

    // wire       db_igual_out      ;
    wire [6:0] db_contagem_out   ;
    wire [6:0] db_memoria_out    ;
    wire [6:0] db_estado_out     ;
    wire       db_timeout_out;
    wire [6:0] db_jogadafeita_out;
    wire       db_clock_out      ;
    wire       db_iniciar_out    ;
    wire       db_tem_jogada_out ;
    wire [11:0] db_Q_out;

    // Configuração do clock
    parameter clockPeriod = 1000; // 

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp5 dut (
      .clock          ( clock_in    ),
      .reset          ( reset_in    ),
      .iniciar        ( iniciar_in  ),
      .chaves         ( chaves_in   ),
      .acertou        ( acertou_out ),
      .errou          ( errou_out   ),
      .pronto         ( pronto_out  ),
      .leds           ( leds_out    ),
      .db_contagem    ( db_contagem_out    ),
      .db_memoria     ( db_memoria_out     ),
      .db_estado      ( db_estado_out      ),
      .db_jogadafeita ( db_jogadafeita_out ),
      .db_clock       ( db_clock_out       ),   
      .db_tem_jogada  ( db_tem_jogada_out  ),
      .db_timeout      (db_timeout_out),
      .db_Q(db_Q_out)
    );

    initial $dumpfile("testbench_errou.vcd");
    initial $dumpvars(0, circuito_exp5_tb_errou);

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;

      /*
       * Cenario de Teste 1 - acerta as 16 jogadas
       */

      // Teste 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(1000*clockPeriod);

      // Teste 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      iniciar_in = 1;
      #(500*clockPeriod);
      iniciar_in = 0;
      // espera
      #(500*clockPeriod);

      // Teste 3. jogada #1 (ajustar chaves para 0001 por 10 periodos de clock
      caso = 3;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(1000*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(1000*clockPeriod);

      // Teste 4. jogada #2 (ajustar chaves para 0010 por 10 periodos de clock
      caso = 4;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(1000*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(1000*clockPeriod);

      // Teste 5. jogada #3 (ajustar chaves para 0100 por 10 periodos de clock
      caso = 5;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(1000*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(4000*clockPeriod);

      // Teste 6. jogada #4 errada (ajustar chaves para 0001 por 5 periodos de clock)
      caso = 6;
      @(negedge clock_in);
      chaves_in = 4'b0001; // jogada certa = 4'b1000
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
