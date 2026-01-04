module KTextEditor.configpage;

/*
    2001-2014 Christoph Cullmann <cullmann@kde.org>
    2005-2014 Dominik Haumann <dhaumann@kde.org>

    LGPL-2.0-or-later

    Translated to D by László Szerémi <laszloszeremi@outlook.com>
*/

import qt.core.object;
import qt.widgets.widget;

/**
 * KTextEditor.ConfigPage
 *
 * Config page interface for the Editor and Plugins.
 *
 * Introduction
 *
 * The class ConfigPage represents a config page.
 * The config pages are usually embedded into a dialog that shows
 * buttons like \c Defaults, \c Reset and \c Apply. If one of the buttons is
 * clicked and the config page sent the signal changed() beforehand the
 * Editor will call the corresponding slot, either defaults(), reset() or
 * apply().
 *
 * To obtain a useful navigation information for displaying to a user see name(),
 * fullName() and icon() functions.
 *
 * Saving and Loading Config Data
 *
 * Saving and loading the configuration data can either be achieved by using
 * the host application's KSharedConfig::openConfig() object, or by using an
 * own configuration file.
 */
extern(C++, KTextEditor) abstract export class ConfigPage : QWidget {
    mixin(Q_OBJECT);
extern(C++) public:
    /**
     * Get a readable name for the config page. The name should be translated.
     * Returns: name of given page index
     */
    abstract QString name() const;
    /**
     * Get a readable full name for the config page. The name
     * should be translated.
     *
     * Example: If the name is "Filetypes", the full name could be
     * "Filetype Specific Settings". For "Shortcuts" the full name would be
     * something like "Shortcut Configuration".
     * Returns: full name of given page index, default implementation returns name()
     */
    abstract QString fullname() const;
    /**
     * Get an icon for the config page.
     * Returns icon for the given page index
     */
    abstract QIcon icon() const;
    /*!
     * This slot is called whenever the button \c Apply or \c OK was clicked.
     * Apply the changed settings made in the config page now.
     */
    abstract void apply() @QSlot;

    /*!
     * This slot is called whenever the button \c Reset was clicked.
     * Reset the config page settings to the initial state.
     */
    abstract void reset() @QSlot;

    /*!
     * Sets default options
     * This slot is called whenever the button \c Defaults was clicked.
     * Set the config page settings to the default values.
     */
    abstract void defaults() @QSlot;


    /*!
     * Emit this signal whenever a config option changed.
     */
    abstract void changed() @QSignal;
private:
    const ConfigPagePrivate d;
}
