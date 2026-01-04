module KTextEditor.mainwindow;

import qt.core.object;
import qt.core.list;
import qt.widgets.widget;

import KTextEditor.plugin;

/**
 * \class KTextEditor::MainWindow
 * \inmodule KTextEditor
 * \inheaderfile KTextEditor/MainWindow
 *
 * \brief This class allows the application that embeds the KTextEditor component to
 * allow it to access parts of its main window.
 *
 * For example the component can get a place to show view bar widgets (e.g. search&replace, goto line, ...).
 * This is useful to e.g. have one place inside the window to show such stuff even if the application allows
 * the user to have multiple split views available per window.
 *
 * The application must pass a pointer to the MainWindow object to the createView method on view creation
 * and ensure that this main window stays valid for the complete lifetime of the view.
 *
 * It must not reimplement this class but construct an instance and pass a pointer to a QObject that
 * has the required slots to receive the requests.
 *
 * \l kte_plugin_hosting
 */

extern(C++, KTextEditor) class MainWindow : QObject {
    mixin(Q_OBJECT);
public @nogc:
    this(QObject parent);
    ~this();
extern(C++) public @nogc:
    /**
     * Get the toplevel widget.
     *
     * Returns the real main window widget, nullptr if not available
     */
    QWidget window();
    /**
     * Accessor to the XMLGUIFactory.
     *
     * Returns: the mainwindow's KXMLGUIFactory, nullptr if not available
     */
    KXMLGUIFactory guiFactory();
    /**
     * This signal is emitted for every unhandled ShortcutOverride in the window
     * Params:
     *   e = is the responsible event
     */
    void unhandledShortcutOverride(QEvent e) @QSignal;
    /**
     * Get a list of all views for this main window.
     *
     * It is beneficial if the list is sorted by most recently used,
     * as the library will e.g. try to use the most recent used url() by walking over this
     * list for save and other such things.
     *
     * Returns: all views, might be empty!
     */
    QList!KTextEditor.View views();
    /**
     * Access the active view.
     * Returns: active view, nullptr if not available
     */
    KTextEditor.View activeView();
    /**
     * Activate the view with the corresponding \a document.
     * If none exist for this document, create one
     * Params:
     *   document = is the document
     *
     * Returns: activated view of this document,
     *         return nullptr if not possible
     */
    KTextEditor.View activateView(KTextEditor.Document document);
    /**
     * Open the document URL with the given encoding.
     * Params:
     *   url = is the document's URL
     *   encoding = is the preferred encoding. If encoding is QString() the
     * encoding will be guessed or the default encoding will be used.
     *
     * Returns: a pointer to the created view for the new document, if a document
     *         with this url is already existing, its view will be activated,
     *         return nullptr if not possible
     */
    KTextEditor.View openUrl(const ref QUrl url, const ref QString encoding);
    /**
     * Close selected view
     * Params:
     *   view = is the view to close
     *
     * Returns: true if view was closed
     */
    bool closeView(KTextEditor.View view);
    /**
     * Split current view space according to \a orientation
     * Params:
     *   orientation = defines the split orientation (horizontal or vertical)
     */
    void splitView(Qt.Orientation orientation);
    /**
     * Close the split view that contains the given view.
     * Params:
     *   view = is the view.
     *
     * Returns: true if the split view was closed.
     */
    bool closeSplitView(KTextEditor.View view);
    /**
     * Returns true if the given views `view1` and `view2` share
     * the same split view, false otherwise.
     */
    bool viewsInSameSplitView(KTextEditor.View view1, KTextEditor.View view2);
    /**
     * This signal is emitted whenever the active view changes.
     * Params:
     *   view = is the new active view
     */
    void viewChanged(KTextEditor.View view) @QSignal;
    /**
     * This signal is emitted whenever a new view is created
     * Params:
     *   view = is the view that was created
     */
    void viewCreated(KTextEditor.View view) @QSignal;
    /**
     * Try to create a view bar for the given view.
     * Params:
     *   view = is the view for which we want a view bar
     *
     * Returns: suitable widget that can host view bars widgets or nullptr
     */
    QWidget createViewBar(KTextEditor.View view);
    /**
     * Delete the view bar for the given view.
     * Params:
     *   view is the view for which we want to delete the view bar
     */
    void deleteViewBar(KTextEditor.View view);
    /**
     * Add a widget to the view bar.
     * Params:
     *   view = is the view for which the view bar is used
     *   bar = is the widget, shall have the viewBarParent() as parent widget
     */
    void addWidgetToViewBar(KTextEditor.View view, QWidget bar);
    /**
     * Show the view bar for the given view
     * Params:
     *   view = is the view for which the view bar is used
     */
    void showViewBar(KTextEditor.View view);
    /**
     * Hide the view bar for the given view
     * Params:
     *   view is the view for which the view bar is used
     */
    void hideViewBar(KTextEditor.View view);
    /**
        enum KTextEditor::MainWindow::ToolViewPosition

        Toolview position.
        A toolview can only be at one side at a time.
     */
    enum ToolViewPosition {
        Left = 0,       ///Left side
        Right = 1,      ///Right side
        Top = 2,        ///Top side
        Bottom = 3      ///Bottom side
    }
    /**
     * Create a new toolview with unique `identifier` at side `pos`
     * with `icon` and caption `text`. Use the returned widget to embed
     * your widgets.
     * Params:
     *   plugin = is the plugin which owns this tool view
     *   identifier = is unique identifier for this toolview
     *   pos = is the position for the toolview, if we are in session restore,
     * this is only a preference
     *   icon = is the icon to use in the sidebar for the toolview
     *   text = is translated text (i18n()) to use in addition to icon
     *
     * Returns: created toolview on success, otherwise NULL
     */
    QWidget createToolView(KTextEditor.Plugin plugin, const ref QString identifier,
            KTextEditor.MainWindow.ToolViewPosition pos, const ref QIcon icon, const ref QString text);
    /**
     * Move the toolview `widget` to position `pos`.
     * Params:
     *   widget = is the toolview to move, where the widget was constructed
     * by createToolView().
     *   pos = is the new position to move the widget to
     *
     * Returns: true on success, otherwise false
     */
    bool moveToolView(QWidget widget, KTextEditor.MainWindow.ToolViewPosition pos);
    /**
     * Show the toolview widget.
     * Params:
     *   widget = is the toolview to show, where the widget was constructed
     * by createToolView().
     *
     * Returns: true on success, otherwise false
     * TODO: add focus parameter: bool showToolView (QWidget *widget, bool giveFocus );
     */
    bool showToolView(QWidget widget);
    /**
     * Hide the toolview widget.
     * Params:
     *   widget is the toolview to hide, where the widget was constructed
     * by createToolView().
     *
     * Returns: true on success, otherwise false
     */
    bool hideToolView(QWidget widget);
    /**
     * Shows the `plugin`'s config page. The `page` specifies which
     * config page will be shown, see KTextEditor.Plugin.configPages().
     *
     * Returns: true on success, otherwise false
     * since 5.63
     */
    bool showPluginConfigPage(KTextEditor.Plugin plugin, int page);
    /**
     * Get a plugin view for the plugin with with identifier `name`.
     * Params:
     *   name = is the plugin's name
     *
     * Returns: pointer to the plugin view if a plugin with `name` is loaded and has a view for this mainwindow,
     *         otherwise NULL
     */
    QObject pluginView(const ref QString name);
    /**
     * This signal is emitted when the view of some Plugin is created for this main window.
     * Params:
     *   name = is the name of the plugin
     *   pluginView = is the new plugin view
     */
    void pluginViewCreated(const ref QString name, QObject pluginView) @QSignal;
    /**
     * This signal is emitted when the view of some Plugin got deleted.
     * warning: Do not access the data referenced by the pointer, it is already invalid.
     * Use the pointer only to remove mappings in hash or maps
     * Params:
     *   name = is the name of the plugin
     *   pluginView = is the deleted plugin view
     */
    void pluginViewDeleted(const ref QString name, QObject pluginView) @QSignal;
    /**
     * Add a widget to the main window.
     * This is useful to show non-KTextEditor.View widgets in the main window.
     * The host application should try to manage this like some KTextEditor.View (e.g. as a tab) and provide
     * the means to close it.
     * Params:
     *   widget = is the widget to add
     *
     * Returns: success, if false, the plugin needs to take care to show the widget itself, otherwise
     *         the main window will take ownership of the widget
     * since 5.98
     */
    bool addWidget(QWidget widget);
    /**
     * Remove this `widget` from this mainwindow. The widget will be deleted afterwards
     * Params:
     *   widget = is the widget to be removed
     * Returns: true on success
     * since 6.0
     */
    bool removeWidget(QWidget widget);
    /**
     * Returns the list of non-KTextEditor.View widgets in this main window.
     * since 6.0
     */
    QWidgetList widgets();
    /**
     * Returns the currently active widget. It can be a non-KTextEditor.View widget or a KTextEditor.View
     * Since 6.0
     */
    QWidget activeWidget();
    /**
     * Activate `widget`. If the widget is not present in the window, it will be added to the window.
     * Params: :
     *   widget = is the widget to activate
     *
     * since 6.0
     */
    void activateWidget(QWidget widget);
    /**
     * Emitted when a widget was added to this window.
     * Params:
     *   widget = is the widget that was added
     *
     * since 6.0
     */
    void widgetAdded(QWidget widget) @QSignal;
    /**
     * Emitted when a widget was added to this window.
     * Params:
     *   widget = is the widget that was removed
     *
     * since 6.0
     */
    void widgetRemoved(QWidget widget) @QSignal;
    /**
     * Display a message to the user.
     * The host application might show this inside a dedicated output view.
     *
     * \a message is the incoming message we shall handle
     *
     * Returns true, if the host application was able to handle the message, else false
     * \since 5.98
     *
     * details of message format:
     *
     * message text, will be trimmed before output
     *
     *    message["text"] = i18n("your cool message")
     *
     * the text will be split in lines, all lines beside the first can be collapsed away
     *
     * message type, we support at the moment
     *
     *    message["type"] = "Error"
     *    message["type"] = "Warning"
     *    message["type"] = "Info"
     *    message["type"] = "Log"
     *
     * this is take from https://microsoft.github.io/language-server-protocol/specification#window_showMessage MessageType of LSP
     *
     * will lead to appropriate icons/... in the output view
     *
     * a message should have some category, like Git, LSP, ....
     *
     *    message["category"] = i18n(...)
     *
     * will be used to allow the user to filter for
     *
     * one can additionally provide a categoryIcon
     *
     *    message["categoryIcon"] = QIcon(...)
     *
     * the categoryIcon icon QVariant must contain a QIcon, nothing else!
     *
     * A string token can be passed to allow to replace messages already send out with new ones.
     * That is useful for e.g. progress output
     *
     *     message["token"] = "yourmessagetoken"
     *
     */
    bool showMessage(const ref QVariantMap message);
private:
    MainWindowPrivate d;
}
