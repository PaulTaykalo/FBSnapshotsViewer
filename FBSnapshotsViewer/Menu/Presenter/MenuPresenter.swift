//
//  MenuPresenter.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa
import Sparkle

class MenuPresenter {
    fileprivate let application: Application
    fileprivate let updater: Updater
    let configuration: Configuration
    var wireframe: MenuWireframe?
    var interactor: MenuInteractorInput?
    weak var userInterface: MenuUserInterface?

    init(configuration: Configuration = Configuration.default(), application: Application = NSApp, updater: Updater = SUUpdater.shared()) {
        self.application = application
        self.configuration = configuration
        self.updater = updater
    }
}

// MARK: - MenuModuleInterface
extension MenuPresenter: MenuModuleInterface {
    func checkForUpdates() {
        updater.checkForUpdates()
    }

    func showTestResults() {
        guard let testResults = interactor?.foundTestResults, !testResults.isEmpty else {
            return
        }

        userInterface?.setNewTestResults(available: false)
        wireframe?.showTestResultsModule(with: testResults)
    }

    func showApplicationMenu() {
        userInterface?.popUpOptionsMenu()
    }

    func showPreferences() {
        wireframe?.showPreferencesModule()
    }

    func quit() {
        application.terminate(self)
    }

    func start() {
        interactor?.startXcodeBuildsListening(derivedDataFolder: configuration.derivedDataFolder)
    }
}

// MARK: - MenuInteractorOutput
extension MenuPresenter: MenuInteractorOutput {
    func didFindNewTestResult(_ testResult: SnapshotTestResult) {
        userInterface?.setNewTestResults(available: true)
    }

    func didFindNewTestLogFile(at path: String) {
        interactor?.startSnapshotTestResultListening(fromLogFileAt: path)
    }
}
