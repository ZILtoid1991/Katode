module KTextEditor.plugin;

/*
    2001-2014 Christoph Cullmann <cullmann@kde.org>
    2005-2014 Dominik Haumann <dhaumann@kde.org>

    LGPL-2.0-or-later

    Translated to D by László Szerémi <laszloszeremi@outlook.com>
*/


import qt.core.object;

import KTextEditor.configpage;

/**
 * KTextEditor.Plugin
 *
 * KTextEditor Plugin interface.
 *
 * Introduction
 *
 * The Plugin class provides methods to create loadable plugins for the
 * KTextEditor framework. The Plugin class itself a function createView()
 * that is called for each MainWindow. In createView(), the plugin is
 * responsible to create tool views through MainWindow::createToolView(),
 * hook itself into the menus and toolbars through KXMLGuiClient, and attach
 * itself to Views or Documents.
 *
 * Plugin Config Pages
 *
 * If your plugin needs config pages, override the functions configPages()
 * and configPage() in your plugin as follows:
 * ```
 * class MyPlugin : public KTextEditor::Plugin
 * {
 *     Q_OBJECT
 * public:
 *     // ...
 *     int configPages() const override;
 *     ConfigPage *configPage(int number, QWidget *parent) override;
 * };
 * ```
 * The host application will call configPage() for each config page.
 *
 * Session Management
 *
 * As an extension a Plugin can implement the SessionConfigInterface. This
 * interface provides functions to read and write session related settings.
 * If you have session dependent data additionally derive your Plugin from
 * this interface and implement the session related functions, for example:
 * ```
 * class MyPlugin : public KTextEditor::Plugin,
 *                  public KTextEditor::SessionConfigInterface
 * {
 *     Q_OBJECT
 *     Q_INTERFACES(KTextEditor::SessionConfigInterface)
 * public:
 *     // ...
 *     void readSessionConfig (const KConfigGroup& config) override;
 *     void writeSessionConfig (KConfigGroup& config) override;
 * };
 * ```
 *
 * Note on D
 *
 * By default, D does not mangle constructors and destructors of C++ classes.
 * However, just like direct mangling of Rust and Zig symbols through
 * metaprogramming, it can be done.
 */

extern(C++, KTextEditor) abstract export class Plugin : QObject {
    mixin(Q_OBJECT);
extern(C++) public:

    /**
     * Create a new View for this plugin for the given KTextEditor::MainWindow.
     * This may be called arbitrary often by the application to create as much
     * views as MainWindows exist. The application will take care to delete
     * a view whenever a MainWindow is closed, so you do not need to handle
     * deletion of the view yourself in the plugin.
     *
     * Note: Session configuration: The host application will try to cast the
     *       returned QObject with \a qobject_cast into the SessionConfigInterface.
     *       This way, not only your Plugin, but also each Plugin view can have
     *       session related settings.
     * Params:
     *   mainWindow = is the MainWindow for which a view should be created
     *
     * Returns: the new created view or NULL
     */
    abstract QObject createView(KTextEditor.MainWindow mainWindow);
    /*!
     * Get the number of available config pages.
     *
     * If a number < 1 is returned, it does not support config pages.
     *
     * Returns number of config pages, default implementation says 0
     */
    abstract int configPages() const;

    /*!
     * Get the config page with the \a number, config pages from 0 to
     * configPages()-1 are available if configPages() > 0.
     *
     * \a number is the index of config page
     *
     * \a parent is the parent widget for config page
     *
     * Returns created config page or NULL, if the number is out of bounds, default implementation returns NULL
     */
    abstract ConfigPage* configPage(int number, QWidget parent);


}
