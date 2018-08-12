require 'spec_helper'

include Eucalypt::Helpers

describe Eucalypt do
  describe Generate do
    describe 'Scaffold' do
      before(:all) { @name = 'test' }
      subject do
        {
          controller: Inflect.new(:controller, @name),
          model: Inflect.new(:model, @name),
          helper: Inflect.new(:helper, @name),
          policy: Inflect.new(:policy, @name)
        }
      end

      describe 'no options' do
        context 'without columns' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate scaffold #{@name}" }
            @migration = tmp { find_migration "create_#{Inflect.resources @name}" }
            @contents = tmp { File.open @migration, &:read }
          end
          after(:all) { Temporary.clear }

          it 'should generate a controller' do
            expect(tmp { File.file? subject[:controller].file_path }).to be true
          end

          it 'should generate a controller spec' do
            expect(tmp { File.file? subject[:controller].spec_path }).to be true
          end

          it 'should generate a model' do
            expect(tmp { File.file? subject[:model].file_path }).to be true
          end

          it 'should generate a model spec' do
            expect(tmp { File.file? subject[:model].spec_path }).to be true
          end

          it 'should generate a migration' do
            expect(tmp { File.file? @migration }).to be true
          end

          it 'should generate a table' do
            expect(@contents).to include "create_table :#{Inflect.resources @name}"
          end

          it 'should not have any columns' do
            expect(@contents.lines.count).to be 5
          end

          it 'should generate a helper' do
            expect(tmp { File.file? subject[:helper].file_path }).to be true
          end

          it 'should generate a helper spec' do
            expect(tmp { File.file? subject[:helper].spec_path }).to be true
          end
        end

        context 'with columns' do
          before(:all) do
            Temporary.create_app
            declarations = %w[col1:string col2:integer col3:decimal]
            @columns = {}
            declarations.each do |d|
              column, type = d.split ?:
              @columns[column.to_sym] = type
            end
            tmp { execute "generate scaffold #{@name} #{declarations*' '}" }
            @migration = tmp { find_migration "create_#{Inflect.resources @name}" }
            @contents = tmp { File.open @migration, &:read }
          end
          after(:all) { Temporary.clear }

          it 'should generate a controller' do
            expect(tmp { File.file? subject[:controller].file_path }).to be true
          end

          it 'should generate a controller spec' do
            expect(tmp { File.file? subject[:controller].spec_path }).to be true
          end

          it 'should generate a model' do
            expect(tmp { File.file? subject[:model].file_path }).to be true
          end

          it 'should generate a model spec' do
            expect(tmp { File.file? subject[:model].spec_path }).to be true
          end

          it 'should generate a migration' do
            expect(tmp { File.file? @migration }).to be true
          end

          it 'should generate a table' do
            expect(@contents).to include "create_table :#{Inflect.resources @name}"
          end

          it 'should have the correct column names and types' do
            expect(@contents).to include *@columns.map {|c,t| "t.#{t} #{c.inspect}"}
          end

          it 'should generate a helper' do
            expect(tmp { File.file? subject[:helper].file_path }).to be true
          end

          it 'should generate a helper spec' do
            expect(tmp { File.file? subject[:helper].spec_path }).to be true
          end
        end
      end
      describe 'options' do
        describe '--no, -n' do
          # Should be 64 combos including empty: \sum_{k=0}^6\binom{6}{k}
          context '[empty]' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n ;" }
            end
            after(:all) { Temporary.clear }

            it "should generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be true
            end
            it "should generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be true
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
          context 'c cs m ms h hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs m ms h hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs m ms h' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs m ms h" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs m ms hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs m ms hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs m ms' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs m ms" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
          context 'c cs m h hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs m h hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs m h' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs m h" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs m hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs m hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs m' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs m" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
          context 'c cs ms h hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs ms h hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs ms h' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs ms h" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs ms hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs ms hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs ms' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs ms" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
          context 'c cs h hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs h hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs h' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs h" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c cs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c cs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
          context 'c m ms h hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c m ms h hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c m ms h' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c m ms h" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c m ms hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c m ms hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c m ms' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c m ms" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
          context 'c m h hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c m h hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c m h' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c m h" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c m hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c m hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c m' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c m" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "shouldn't generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be false
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
          context 'c ms h hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c ms h hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c ms h' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c ms h" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c ms hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c ms hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c ms' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c ms" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "shouldn't generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be false
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
          context 'c h hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c h hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c h' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c h" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "shouldn't generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be false
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c hs' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c hs" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "shouldn't generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be false
            end
          end
          context 'c' do
            before(:all) do
              Temporary.create_app
              tmp { execute "generate scaffold #{@name} -n c" }
            end
            after(:all) { Temporary.clear }

            it "shouldn't generate a controller" do
              expect(tmp { File.file? subject[:controller].file_path }).to be false
            end
            it "shouldn't generate a controller spec" do
              expect(tmp { File.file? subject[:controller].spec_path }).to be false
            end
            it "should generate a model" do
              expect(tmp { File.file? subject[:model].file_path }).to be true
            end
            it "should generate a model spec" do
              expect(tmp { File.file? subject[:model].spec_path }).to be true
            end
            it "should generate a helper" do
              expect(tmp { File.file? subject[:helper].file_path }).to be true
            end
            it "should generate a helper spec" do
              expect(tmp { File.file? subject[:helper].spec_path }).to be true
            end
          end
        end
        context '--rest, -r' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate scaffold #{@name} -r --no-table" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a controller' do
            expect(tmp { File.file? subject[:controller].file_path }).to be true
          end

          it 'should pluralize the controller route' do
            route = Inflect.route(subject[:controller].resources)
            expect(tmp { File.open subject[:controller].file_path, &:read }).to include "route: '/#{route}'"
          end

          it 'should contain all of the BREAD methods' do
            methods = ['GET - Browse', 'GET - Read', 'POST - Edit', 'POST - Add', 'POST - Delete']
            expect(tmp { File.open subject[:controller].file_path, &:read }).to include *methods
          end
        end
        context '--policy, -p' do
          before(:all) do
            Temporary.create_app '-wp'
            tmp { execute "generate scaffold #{@name} -p --no-table" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a policy file' do
            expect(tmp { File.file? subject[:policy].file_path }).to be true
          end

          it 'should generate a controller' do
            expect(tmp { File.file? subject[:controller].file_path }).to be true
          end

          it 'should not pluralize the controller route' do
            expect(tmp { File.open subject[:controller].file_path, &:read }).to include "route: '/#{@name}'"
          end

          it 'should not contain BREAD methods' do
            methods = ['GET - Browse', 'GET - Read', 'POST - Edit', 'POST - Add', 'POST - Delete']
            expect(tmp { File.open subject[:controller].file_path, &:read }).not_to include *methods
          end

          it 'should not contain any Pundit authorization' do
            expect(tmp { File.open subject[:controller].file_path, &:read }).not_to include 'Pundit authorization'
          end
        end
        context '--rest --policy, -rp' do
          before(:all) do
            Temporary.create_app '-wp'
            tmp { execute "generate scaffold #{@name} -rp --no-table" }
          end
          after(:all) { Temporary.clear }

          it 'should generate a policy file' do
            expect(tmp { File.file? subject[:policy].file_path }).to be true
          end

          it 'should generate a controller' do
            expect(tmp { File.file? subject[:controller].file_path }).to be true
          end

          it 'should pluralize the controller route' do
            route = Inflect.route(subject[:controller].resources)
            expect(tmp { File.open subject[:controller].file_path, &:read }).to include "route: '/#{route}'"
          end

          it 'should contain all of the BREAD methods' do
            methods = ['GET - Browse', 'GET - Read', 'POST - Edit', 'POST - Add', 'POST - Delete']
            expect(tmp { File.open subject[:controller].file_path, &:read }).to include *methods
          end

          it 'should contain Pundit authorization' do
            expect(tmp { File.open subject[:controller].file_path, &:read }).to include 'Pundit authorization'
          end
        end
        context '--no-table' do
          before(:all) do
            Temporary.create_app
            tmp { execute "generate scaffold #{@name} --no-table" }
          end
          after(:all) { Temporary.clear }

          it "shouldn't create a table migration" do
            expect(tmp { Dir[File.join 'db', 'migrate', '*.rb'] }).to be_empty
          end
        end
      end
    end
  end
end