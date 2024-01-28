/* --------------------------------------------------------------------
 * Arquivo   : circuito_exp4_tb.vhd
 * Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog para circuito da Experiencia 4 
 *
 *             1) plano de teste: 16 casos de teste
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     16/01/2024  1.0     Edson Midorikawa  versao inicial
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module circuito_exp4_tb_errou;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;
    wire       pronto_out;
    wire       errou_out;
    wire       acertou_out;
    wire       db_igual_out;
    wire       db_iniciar_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_chaves_out;
    wire [6:0] db_estado_out;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp4 dut (
      .clock      (clock_in),
      .reset      (reset_in),
      .iniciar    (iniciar_in),
      .chaves     (chaves_in),
      .pronto     (pronto_out),
      .db_igual   (db_igual_out),
      .db_iniciar (db_iniciar_out),
      .db_contagem(db_contagem_out),
      .db_memoria (db_memoria_out),
      .db_chaves  (db_chaves_out),
      .acertou    (acertou_out),
      .errou      (errou_out),
      .db_estado  (db_estado_out)
    );

    initial $dumpfile("testbench_errou.vcd");
    initial $dumpvars(0, circuito_exp4_tb_errou);

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

      // Teste 1 (resetar circuito)
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;

      // Teste 2 (iniciar=0 por 5 periodos de clock)
      caso = 2;
      #(clockPeriod);

      // Teste 3 (ajustar chaves para 0001, acionar iniciar por 1 periodo de clock)
      caso = 3;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      // pulso em iniciar
      iniciar_in = 1;
      #(clockPeriod);
      iniciar_in = 0;

      // Teste 4 (manter chaves em 0001 por 1 periodo de clock)
      caso = 4;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(clockPeriod);

      // Teste 5 (manter chaves em 0001 por 1 periodo de clock)
      caso = 5;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(clockPeriod);

      // Teste 6 (manter chaves em 0010 por 1 periodo de clock)
      caso = 6;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(clockPeriod);

      // Teste 7 (manter chaves em 0010 por 3 periodos de clock)
      caso = 7;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(3*clockPeriod);

      // Teste 8 (manter chaves em 0100 por 3 periodos de clock)
      caso = 8;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);

      // Teste 9 (manter chaves em 0100 por 9 periodos de clock - divergência com a memória[3])
      caso = 9;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(9*clockPeriod);

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
