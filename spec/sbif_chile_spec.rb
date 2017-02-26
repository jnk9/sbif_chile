require 'spec_helper'
require 'sbif_chile'
require 'pry-byebug'

describe SbifChile do

  before(:each) do
    @sbif_chile = SbifChile.new
  end

  it "has a version number" do
    expect(SbifChile::VERSION).not_to be nil
  end

  it 'date current' do
    @sbif_chile.indicators_current
    binding.pry
  end

  describe '#date_range'
    it 'get data by range all resource' do
      data_euro = @sbif_chile.date_range('euro')
      binding.pry
      data_ipc = @sbif_chile.date_range('ipc')
      data_tmc = @sbif_chile.date_range('tmc')
      data_tab = @sbif_chile.date_range('tab')
      data_utm = @sbif_chile.date_range('utm')
      data_uf = @sbif_chile.date_range
      data_dolar = @sbif_chile.date_range('dolar')
      data_uf.each { |d| puts "UF | Fecha #{d[:date]} - Valor #{d[:value]}" } unless data_uf.nil?
      data_dolar.each { |d| puts "DOLAR | Fecha #{d[:date]} - Valor #{d[:value]}" } unless data_dolar.nil?
      data_utm.each { |d| puts "UTM | Fecha #{d[:date]} - Valor #{d[:value]}" } unless data_utm.nil?
      data_tab.each { |d| puts "TAB | Fecha #{d[:date]} - Valor #{d[:value]}" } unless data_tab.nil?
      data_tmc.each { |d| puts "TMC | Fecha #{d[:date]} - Valor #{d[:value]} - Tipo #{d[:type]}" } unless data_tmc.nil?
      data_ipc.each { |d| puts "IPC | Fecha #{d[:date]} - Valor #{d[:value]}" } unless data_ipc.nil?
      data_euro.each { |d| puts "EURO | Fecha #{d[:date]} - Valor #{d[:value]}" } unless data_euro.nil?
    end
end
