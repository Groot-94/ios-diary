//
//  DiaryListViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/17.
//

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - properties
    
    private var tableView = UITableView()
    private var diaryManager: DiaryManager?
    private var diaryItems: [DiaryModel]?
    
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        diaryManager = CoreDataManager()
        configureNavigationBarItems()
        configureView()
        configureViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadView()
    }
    
    // MARK: - methods

    private func reloadView() {
        
        tableView.reloadData()
    }
    
    private func deleteDiaryData(index: Int) {
//        guard let createdAt = diaryItems?[index].createdAt else { return }
        
        reloadView()
    }
    
    private func shareAlertActionDidTap(index: Int) {
        let title = diaryItems?[index].title
        let activityViewController = UIActivityViewController(activityItems: [title as Any],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
    
    private func deleteAlertActionDidTap(index: Int) {
        let alertController = UIAlertController(title: Design.alertControllerTitle,
                                                message: Design.alertControllerMessage,
                                                preferredStyle: .alert)
        
        let cancelAlertAction = UIAlertAction(title: Design.alertCancelAction,
                                              style: .cancel)
        let deleteAlertAction = UIAlertAction(title: Design.alertDeleteAction,
                                              style: .destructive) { _ in self.deleteDiaryData(index: index)}
        
        alertController.addAction(cancelAlertAction)
        alertController.addAction(deleteAlertAction)
        
        present(alertController, animated: true)
    }
    
    private func configureNavigationBarItems() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(tappedPlusButton))
        
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.title = Design.navigationTitle
    }
    
    @objc private func tappedPlusButton() {
        let registerViewController = DiaryRegisterViewController()
        registerViewController.delegate = self
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    // MARK: - Layout Methods
    
    private func configureView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryTableViewCell.self,
                           forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
    }
    
    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
}

// MARK: - extensions

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        diaryItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.reuseIdentifier)
                as? DiaryTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = diaryItems?[indexPath.row].title
        cell.dateLabel.text = diaryItems?[indexPath.row].createdAt.convertDate()
        cell.bodyLabel.text = diaryItems?[indexPath.row].body
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryDetailViewController = DiaryDetailViewController()
        diaryDetailViewController.delegate = self
        diaryDetailViewController.diaryDetailData = diaryItems?[indexPath.row]
        
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: Design.alertDeleteAction, handler: { _, _, completionHaldler in
            self.deleteAlertActionDidTap(index: indexPath.row)
            completionHaldler(true)
        })
        
        let shareSwipeAction = UIContextualAction(style: .normal, title: Design.alertShareAction, handler: { _, _, completionHaldler in
            self.shareAlertActionDidTap(index: indexPath.row)
            completionHaldler(true)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction, shareSwipeAction])
    }
}

extension DiaryListViewController: DiaryDetailViewControllerDelegate, DiaryRegisterViewControllerDelegate {
    func createDiary(_ diaryInfo: DiaryProtocol) {
        diaryManager?.create(diaryInfo)
        tableView.reloadData()
    }
    
    func deleteDiary(createdAt: Double) {
        diaryManager?.delete(createdAt: createdAt)
        tableView.reloadData()
    }
    
    func updateDiary(_ diaryInfo: DiaryProtocol) {
        diaryManager?.update(diaryInfo)
        tableView.reloadData()
    }
    
    
}
// MARK: - Design

private enum Design {
    static let navigationTitle = "일기장"
    static let alertControllerTitle = "진짜요?"
    static let alertControllerMessage = "정말로 삭제하시겠어요?🐒"
    static let alertCancelAction = "취소"
    static let alertDeleteAction = "삭제"
    static let alertShareAction = "공유"
}
