module SimpleForm
  module Components
    module OptionalLabels
      module ClassMethods
        def translate_optional_html
          i18n_cache :translate_optional_html do
            I18n.t(
              :"simple_form.optional.html",
              default: translate_optional_text
            )
          end
        end

        def translate_optional_text
          I18n.t(:"simple_form.optional.text", default: 'optional')
        end
      end

      protected

      def required_label_text #:nodoc:
        if required_field?
          self.class.translate_required_html.dup
        else
          self.class.translate_optional_html.dup
        end
      end
    end
  end
end
