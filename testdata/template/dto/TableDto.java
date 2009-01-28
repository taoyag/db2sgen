
/**
 * テーブル [<%= table.table_name%>] の1レコードを表すDto.
 * <p>
 * generated at <%= Time.now %>. 
 * </p>
 * @author db2sgen
 */
public class <%= m.class_name table %>Dto {
    <% table.columns.each do |c| -%>

    /**
     * <%= c.human_name %>.
     * <p>
     * [<%= table.table_name %>.<%= c.name %>]
     * </p>
     */
    private <%= m.type_name c %> <%= m.name c %>;
    <% end -%>

    /**
     * コンストラクタ.
     */
    public <%= m.class_name table %>() {
    }
    <% table.columns.each do |c| -%>

    /**
     * <%= m.name c %> の値を返す.
     * <p>
     * [<%= table.table_name %>.<%= c.name %>]
     * </p>
     * @return <%= m.name c %>
     */
    public <%= m.type_name c %> get<%= m.name(c).capitalize %>() {
        return <%= m.name c %>;
    }

    /**
     * <%= m.name c %> の値を設定する.
     * <p>
     * [<%= table.table_name %>.<%= c.name %>]
     * </p>
     * @param <%= m.name c %> <%= m.name c %>
     */
    public void set<%= m.name(c).capitalize %>(<%= m.type_name c %> <%= m.name c %>) {
        this.<%= m.name c %> = <%= m.name c %>;
    }
    <% end -%>

}

