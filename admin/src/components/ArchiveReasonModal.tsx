import React, { useState } from "react";
import { useT } from "../i18n";

interface ArchiveReasonModalProps {
  onConfirm: (reason: string) => void;
  onCancel: () => void;
}

export const ArchiveReasonModal: React.FC<ArchiveReasonModalProps> = ({
  onConfirm,
  onCancel,
}) => {
  const { t } = useT();
  const [reason, setReason] = useState("");

  return (
    <div
      className="fixed inset-0 z-[300] bg-black/40 flex items-center justify-center p-4"
      onClick={onCancel}
    >
      <div
        className="bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6"
        onClick={(e) => e.stopPropagation()}
      >
        <h3 className="text-base font-bold text-gray-900 mb-1">
          {t("pastCandidates.archiveModal.title")}
        </h3>
        <p className="text-sm text-gray-500 mb-4 leading-relaxed">
          {t("pastCandidates.archiveModal.message")}
        </p>
        <textarea
          autoFocus
          value={reason}
          onChange={(e) => setReason(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter" && !e.shiftKey && reason.trim()) {
              e.preventDefault();
              onConfirm(reason.trim());
            }
          }}
          placeholder={t("pastCandidates.archiveModal.placeholder")}
          rows={3}
          className="w-full text-sm border border-gray-200 rounded-xl px-3 py-2 focus:outline-none focus:ring-1 focus:ring-red-300 resize-none mb-4"
        />
        <div className="flex flex-col gap-2">
          <button
            onClick={() => onConfirm(reason.trim())}
            disabled={!reason.trim()}
            className="w-full py-2 text-sm font-semibold text-white bg-red-500 hover:bg-red-600 disabled:opacity-40 rounded-xl transition-colors"
          >
            {t("pastCandidates.archiveModal.confirm")}
          </button>
          <button
            onClick={() => onConfirm("")}
            className="w-full py-2 text-sm font-semibold text-gray-500 hover:bg-gray-100 rounded-xl transition-colors"
          >
            {t("pastCandidates.archiveModal.skip")}
          </button>
          <button
            onClick={onCancel}
            className="w-full py-2 text-sm font-semibold text-gray-400 hover:bg-gray-50 rounded-xl transition-colors"
          >
            {t("confirm.cancel")}
          </button>
        </div>
      </div>
    </div>
  );
};

// Hook for imperative usage
export function useArchiveReason() {
  const [modal, setModal] = React.useState<{
    onConfirm: (reason: string) => void;
    onCancel: () => void;
  } | null>(null);

  const prompt = () =>
    new Promise<string | null>((resolve) => {
      setModal({
        onConfirm: (reason) => {
          setModal(null);
          resolve(reason);
        },
        onCancel: () => {
          setModal(null);
          resolve(null);
        },
      });
    });

  const element = modal ? (
    <ArchiveReasonModal onConfirm={modal.onConfirm} onCancel={modal.onCancel} />
  ) : null;

  return { prompt, element };
}
