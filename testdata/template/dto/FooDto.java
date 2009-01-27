
public class <%= m.class_name table %>Dto {
    <% table.columns.each do |c| %>
        private <%= m.type_name c %> <%= c.name %>;
    <% end %>


}

