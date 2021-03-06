require 'spec_helper'
require 'app/models/repair'

RSpec.describe Repair do
  describe '#work_order_reference' do
    it 'returns the first work order reference from the repair' do
      repair_data = {
        'repairRequestReference' => '00004578',
        'problemDescription' => 'My bath is broken',
        'priority' => 'N',
        'propertyReference' => '00034713',
        'workOrders' => [
          {
            'workOrderReference' => '00412371',
          },
          {
            'workOrderReference' => '88888888',
          },
        ],
      }
      expect(Repair.new(repair_data).work_order_reference).to eq '00412371'
    end

    context 'when there are no work orders' do
      it 'is nil' do
        repair_data = {
          'repairRequestReference' => '00004578',
          'problemDescription' => 'My bath is broken',
          'priority' => 'N',
          'propertyReference' => '00034713',
        }
        expect(Repair.new(repair_data).work_order_reference).to be_nil
      end
    end

    context 'when workOrders is returned, but is empty' do
      it 'is nil' do
        repair_data = {
          'repairRequestReference' => '00004578',
          'problemDescription' => 'My bath is broken',
          'priority' => 'N',
          'propertyReference' => '00034713',
          'workOrders' => [],
        }

        expect(Repair.new(repair_data).work_order_reference).to be_nil
      end
    end
  end

  describe '#request_reference' do
    it 'returns the request reference from the repair' do
      repair_data = {
        'repairRequestReference' => '00004578',
        'problemDescription' => 'My bath is broken',
        'priority' => 'N',
        'propertyReference' => '00034713',
      }
      expect(Repair.new(repair_data).request_reference).to eq '00004578'
    end
  end

  context 'when there is no reference in the data' do
    it 'raises an error' do
      repair_data = {
        'problemDescription' => 'My bath is broken',
        'priority' => 'N',
        'propertyReference' => '00034713',
      }
      expect { Repair.new(repair_data).request_reference }.to raise_error(KeyError)
    end
  end
end
